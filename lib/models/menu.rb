class Menu
    def initialize
        @todo_array = Todo.all.map {|todo| todo.name}
        @category_array = Category.all.map {|category| category.name}
    end

    def showTodos prompt = TTY::Prompt.new
        
        categoryName = prompt.select("Parker's Todos" "\n", @category_array, "New Category", "Quit")
        if categoryName =='Quit'
            exit
        elsif categoryName =='New Category'
            self.createCategory
        else
            showCategoryTodos(categoryName)
        end
    end

    def createTodo categoryName
        category = Category.all.find{|category| category.name == categoryName }
        puts "what do?"
        todo_name = gets.chomp.capitalize()
        Todo.create(name: todo_name, category: category)
        self.showCategoryTodos(categoryName)
    end

    def createCategory
        puts "what category?"
        category_name = gets.chomp.capitalize()
        Category.create(name: category_name)
        Menu.new.showTodos
    end

    def showCategoryTodos categoryName, prompt = TTY::Prompt.new
        category_todos = Category.all.find{|category| category.name == categoryName }.todos
        category_todo_names = category_todos.map {|todo| todo.name}
        command = prompt.select("#{categoryName}" "\n", category_todo_names, 'Add Todo', 'Random Todo', 'back')
        if command == 'back'
            self.showTodos
        elsif command == 'Random Todo'
            self.randomTodo(category_todo_names, categoryName)
        elsif command == 'Add Todo'
            self.createTodo(categoryName) 
        else
            self.showTodo(command, categoryName)
        end
    end
    
    def showTodo todoName, categoryName, prompt = TTY::Prompt.new
        todoObj = Todo.all.find{|todo| todo.name == todoName } 
        command = prompt.select("#{todoName}" "\n", 'delete', 'update', 'back')
        if command == 'back'
            self.showCategoryTodos(categoryName)
        elsif command == 'delete'
            self.deleteTodo(todoObj, categoryName)
        elsif command == 'update'
            self.updateTodo(todoObj, categoryName)
        end
    end

    def randomTodo todos, categoryName, prompt = TTY::Prompt.new
        input = prompt.select("#{todos[rand(todos.length)]}" "\n", "again", "back")
        if input == 'again'      
            randomTodo(todos, categoryName)
        else 
            self.showCategoryTodos(categoryName)
        end
    end

    def deleteTodo todoObj, categoryName
        todoObj.delete
        self.showCategoryTodos(categoryName)
    end

    def updateTodo todoObj, categoryName
        new_todo_name = gets.chomp.capitalize()
        todoObj.update(name: new_todo_name)
        self.showCategoryTodos(categoryName)
    end

end