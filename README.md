# Todo CLI
- A simple command-line tool for managing tasks in a text file.

# Features
- Add task
- List tasks
- Remove task
- Mark task

#Commands
- todo add task - Adds new task 
- todo rm task - removes a task
- todo ls - lists all task
- todo -m task - mark task as done 
- todo rm -m task - remove marked task
- todo add -h task - add task as high priority
- todo add -m task - add task as low priority

# Installation
    git clone https://github.com/BishwasXD/Todo-CLI.git && \
    cd Todo-CLI && \
    chmod +x bin/todo.sh && \
    sudo mv bin/todo.sh /usr/local/bin/todo && \
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc && \
    source ~/.bashrc

# Update
    cd ~/Todo-CLI && \              
    git pull origin main && \         
    chmod +x bin/todo.sh  && \       
    sudo mv bin/todo.sh /usr/local/bin/todo



![github readme](https://github.com/user-attachments/assets/ba60a42b-75aa-451b-a819-cc2a36a5501f)

    
 
