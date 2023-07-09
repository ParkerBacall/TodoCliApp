class Menu
    def initialize
        @todo_array = Todo.all.map {|todo| todo.name}
    end

    def showTodos prompt = TTY::Prompt.new
        todoName = prompt.select("Parker's Todos" "\n",  @todo_array, "New Todo", "Random Todo", "Quit")
        if todoName == "New Todo"
            self.createTodo
        elsif todoName =='Quit'
            exit
        elsif todoName =='Random Todo'
            self.randomTodo
        else
            showTodo(todoName)
        end
    end

    def createTodo
        puts "what do?"
        todo_name = gets.chomp.capitalize()
        Todo.create(name: todo_name)
        Menu.new.showTodos
    end
    
    def showTodo todoName, prompt = TTY::Prompt.new
        todoObj = Todo.all.find{|todo| todo.name == todoName } 
        id = todoObj.id
        command = prompt.select("#{todoName}" "\n", 'delete', 'update', 'back')

        if command == 'back'
            self.showTodos
        elsif command == 'delete'
            self.deleteTodo(todoObj)
        elsif command == 'update'
            self.updateTodo(todoObj)
        end
    end

    def deleteTodo todoObj
        todoObj.delete
        Menu.new.showTodos
    end

    def updateTodo todoObj
        new_todo_name = gets.chomp.capitalize()
        todoObj.update(name: new_todo_name)
        Menu.new.showTodos
    end

    def randomTodo prompt = TTY::Prompt.new
        input = prompt.select(@todo_array[rand(@todo_array.length)], "again", "back")
        if input == 'again'
            randomTodo
        else 
            self.showTodos
        end
    end

end