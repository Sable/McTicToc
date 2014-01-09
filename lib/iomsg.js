var task, taskManager, io;

function setTaskManager(sio, t, tm) {
    io = sio;
    task = t;
    taskManager = tm;
}

function connect(socket) {
    var data = task.TasksToJS(taskManager.getSome({ status: "running" }));
    data = data.concat(task.TasksToJS(taskManager.getSome({ status: "created" })));

    socket.emit('tasks', { data: data });
}

function emit(message, data) {
    io.sockets.emit(message, data);
}

exports.connect = connect;
exports.emit = emit;
exports.setTaskManager = setTaskManager;
