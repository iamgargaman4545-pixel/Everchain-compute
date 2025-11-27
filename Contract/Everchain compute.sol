// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Everchain Compute
 * @dev A simple compute-task registry where users can submit tasks,
 *      store computation results, and retrieve them.
 */
contract Project {
    struct ComputeTask {
        string taskDescription;
        string result;
        address submittedBy;
        bool isCompleted;
    }

    uint256 public taskCount;
    mapping(uint256 => ComputeTask) public tasks;

    event TaskSubmitted(uint256 indexed taskId, address indexed user, string description);
    event TaskCompleted(uint256 indexed taskId, string result);

    /**
     * @notice Submit a new computation request
     * @param description Description of the compute task
     */
    function submitTask(string calldata description) external {
        taskCount++;
        tasks[taskCount] = ComputeTask(description, "", msg.sender, false);

        emit TaskSubmitted(taskCount, msg.sender, description);
    }

    /**
     * @notice Store a computation result for an existing task
     * @param taskId The ID of the task
     * @param result The computed result
     */
    function storeResult(uint256 taskId, string calldata result) external {
        ComputeTask storage task = tasks[taskId];

        require(task.submittedBy != address(0), "Task does not exist");
        require(!task.isCompleted, "Task already completed");
        require(task.submittedBy == msg.sender, "Only submitter can store result");

        task.result = result;
        task.isCompleted = true;

        emit TaskCompleted(taskId, result);
    }

    /**
     * @notice Retrieve details of a specific task
     * @param taskId The ID of the task
     * @return task struct details
     */
    function getTask(uint256 taskId)
        external
        view
        returns (string memory, string memory, address, bool)
    {
        ComputeTask memory t = tasks[taskId];
        return (t.taskDescription, t.result, t.submittedBy, t.isCompleted);
    }
}

