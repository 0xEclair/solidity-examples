// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Todos {
    struct Todo {
        string text;
        bool completed;
    }
    Todo[] public todos;

    function create(string calldata text) public {
        todos.push(Todo(text, false));

        todos.push(Todo({text: text,completed: false}));

        Todo memory todo;
        todo.text = text;
        todos.push(todo);
    }

    function getTodos() public view returns (Todo[] memory) {
        return todos;
    }

    function length() public view returns (uint) {
        return todos.length;
    }

    function get(uint index) public view returns (string memory text, bool completed) {
        Todo storage todo = todos[index];
        return (todo.text, todo.completed);
    }

    function updateText(uint index, string calldata text) public {
        Todo storage todo = todos[index];
        todo.text = text;
    }

    function toggleCompleted(uint index) public {
        Todo storage todo = todos[index];
        todo.completed = !todo.completed;
    }
}