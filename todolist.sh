    #!/bin/bash


    TODO_FILE="todo.txt"
    REMINDER_FILE="reminders.txt"

    # Function to display usage/help
    usage() {
        echo "Usage: $0 {add|remove|list|prepend|append|sort|deduplicate|setreminder} [task]"
        echo "  add <task> [task2] ...    - Add one or more tasks to the to-do list"
        echo "  remove <task>             - Remove a task from the to-do list"
        echo "  list                      - List all tasks with numbering"
        echo "  prepend <task>            - Prepend a task to the to-do list"
        echo "  append <task>             - Append a task to the to-do list"
        echo "  sort                      - Sort the to-do list alphabetically"
        echo "  deduplicate               - Remove duplicate tasks"
        echo "  setreminder <task> <time> - Set a reminder for a specific task"
        exit 1
    }


    if [ ! -f "$TODO_FILE" ]; then
        touch "$TODO_FILE"
    fi


    if [ ! -f "$REMINDER_FILE" ]; then
        touch "$REMINDER_FILE"
    fi


    add_tasks() {
        for task in "$@"; do
            echo "$task" >> "$TODO_FILE"
            echo "Added: $task"
        done
    }

    remove_task() {
        sed -i "/$1/d" "$TODO_FILE"
        echo "Removed: $1"
    }


    list_tasks() {
        echo "To-Do List:"
        if [ -s "$TODO_FILE" ]; then
            nl -w 2 -s '. ' "$TODO_FILE"
        else
            echo "No tasks available."
        fi
    }


    prepend_task() {
        sed -i "1i$1" "$TODO_FILE"
        echo "Prepended: $1"
    }


    append_task() {
        echo "$1" >> "$TODO_FILE"
        echo "Appended: $1"
    }


    sort_tasks() {
        sort -o "$TODO_FILE" "$TODO_FILE"
        echo "Sorted tasks."
    }


    deduplicate_tasks() {
        awk '!seen[$0]++' "$TODO_FILE" > "$TODO_FILE.tmp"
        mv "$TODO_FILE.tmp" "$TODO_FILE"
        echo "Removed duplicate tasks (order preserved)."
    }



    set_reminder() {
        task="$1"
        reminder_time="$2"
        if [ -z "$task" ] || [ -z "$reminder_time" ]; then
            echo "Error: Task and reminder time must be provided."
            usage
        fi
        echo "$task - Reminder at $reminder_time" >> "$REMINDER_FILE"
        echo "Reminder set for: $task at $reminder_time"
    }

    if [ $# -lt 1 ]; then
        usage
    fi


    case "$1" in
        add)
            if [ $# -lt 2 ]; then
                echo "Error: Missing task(s) to add."
                usage
            fi
            shift  # Shift past the 'add' argument
            add_tasks "$@"
            ;;
        remove)
            if [ $# -lt 2 ]; then
                echo "Error: Missing task to remove."
                usage
            fi
            remove_task "$2"
            ;;
        list)
            list_tasks
            ;;
        prepend)
            if [ $# -lt 2 ]; then
                echo "Error: Missing task to prepend."
                usage
            fi
            prepend_task "$2"
            ;;
        append)
            if [ $# -lt 2 ]; then
                echo "Error: Missing task to append."
                usage
            fi
            append_task "$2"
            ;;
        sort)
            sort_tasks
            ;;
        deduplicate)
            deduplicate_tasks
            ;;
        setreminder)
            if [ $# -lt 3 ]; then
                echo "Error: Missing task or reminder time."
                usage
            fi
            set_reminder "$2" "$3"
            ;;
        *)
            echo "Error: Invalid command."
            usage
            ;;
    esac

