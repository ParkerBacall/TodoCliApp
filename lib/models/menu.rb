class Menu
    def initialize
        @todo_array = Todo.all.map {|todo| todo.name}
        @category_array = Category.all.map {|category| category.name}
    end

    def showTodos prompt = TTY::Prompt.new
        
        categoryName = prompt.select("Parker's Todos" "\n", @category_array, "New Category", "Random", "Quit")
        if categoryName =='Quit'
            exit
        elsif categoryName =='New Category'
            self.createCategory
        elsif categoryName =='Random'
            self.absRandom
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
        categoryObj = Category.all.find{|category| category.name == categoryName }
        command = prompt.select("#{categoryName}" "\n", category_todo_names, 'Add Todo', 'Random Todo', 'Update Category Name', 'Delete Category', 'back')
        if command == 'back'
            self.showTodos
        elsif command == 'Random Todo'
            self.randomTodo(category_todo_names, categoryName)
        elsif command == 'Add Todo'
            self.createTodo(categoryName) 
        elsif command == 'Update Category Name'
            self.updateCategory(categoryObj) 
        elsif command == 'Delete Category'
            self.deleteCategory(categoryObj, category_todos) 
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

    def deleteTodo todoObj, categoryName
        todoObj.delete
        self.showCategoryTodos(categoryName)
    end

    def deleteCategory todoObj, category_todos
        category_todos.map{|todo| todo.delete}
        todoObj.delete
        Menu.new.showTodos
    end

    def updateCategory categoryObj
        new_category_name = gets.chomp.capitalize()
        categoryObj.update(name: new_category_name)
        Menu.new.showTodos
    end

    def updateTodo todoObj, categoryName
        new_todo_name = gets.chomp.capitalize()
        todoObj.update(name: new_todo_name)
        self.showCategoryTodos(categoryName)
    end

    def randomTodo todos, categoryName, prompt = TTY::Prompt.new
        input = prompt.select("#{todos[rand(todos.length)]}" "\n", "again", "back")
        if input == 'again'      
            randomTodo(todos, categoryName)
        else 
            self.showCategoryTodos(categoryName)
        end
    end

    def absRandom prompt = TTY::Prompt.new
        input = prompt.select("#{ @todo_array[rand( @todo_array.length)]}" "\n", "again", "back")
        if input == 'again'      
            absRandom()
        else 
            self.showTodos
        end
    end

end