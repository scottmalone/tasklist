const tasklist = {
  setup: function() {
    tasklist.bindNewTask();
    tasklist.bindEditTask();
    tasklist.bindToggleCompleted();
  },
  bindNewTask: function() {
    $("#new-task-link").click(function() {
      tasklist.getNewTaskForm();
      return false;
    });

    $("#new-task-container").on("submit", "#new-task-form", function (e) {
      const form = $(this);
      const dueDate = new Date(form[0][2]["value"]);
      form[0][2]["value"] = dueDate.toUTCString();
      const url = form.attr('action');

      $.ajax({
        type: "POST",
        url: url,
        data: form.serialize(),
        success: function(response) {
          tasklist.addNewUITask(response);
          tasklist.removeNewTaskForm();
        }
      });

      e.preventDefault();
    });
  },
  bindEditTask: function() {
    $(".panel-group").on("click", ".edit-task-link", function (e) {
      tasklist.getEditTaskForm(this);
      return false;
    });

    $(".panel-group").on("submit", ".edit-task-form", function (e) {
      const form = $(this);
      const dueDate = new Date(form[0][2]["value"]);
      form[0][2]["value"] = dueDate.toUTCString();
      const url = form.attr('action');
      const task = $(form).closest(".task");

      $.ajax({
        type: "PUT",
        url: url,
        data: form.serialize(),
        success: function(response) {
          tasklist.updateUITask(task, response);
        }
      });

      e.preventDefault();
    });
  },
  bindToggleCompleted: function() {
    $(".panel-group").on("click", ".toggle-completed-link", function (e) {
      const link = $(this);
      const task = $(link).closest(".task");
      const taskID = $(task).attr("task_id");
      const newCompletedState = task.hasClass("completed") ? false : true;
      const url = `/api/tasks/${taskID}`;
      $.ajax({
        type: "PUT",
        url: url,
        data: ({ task: { completed: newCompletedState } }),
        success: function(response) {
          tasklist.updateToggleCompletedUI(task);
        }
      });
      return false;
    });
  },
  getNewTaskForm: function() {
    const newTemplate = JST['templates/tasks/new'];
    const html = newTemplate({
      authenticity_token: window._token
    });
    $("#new-task-container").html(html);
    $("#new-task-container .datepicker").datepicker();
  },
  removeNewTaskForm: function() {
    $("#new-task-container").empty();
  },
  addNewUITask: function(response) {
    const template = JST['templates/tasks/show'];
    const dateOptions = { year: 'numeric', month: 'short', day: 'numeric' };
    const dueDate  = new Date(response.data.attributes.due);
    response.data.attributes["due"] = dueDate.toLocaleDateString("en-US", dateOptions);
    const html = template({
      task: response.data.attributes
    });
    $(".panel-group").prepend(html);
  },
  getEditTaskForm: function(link) {
    const task = $(link).closest(".task");
    const taskBody = $(task).find(".panel-body");
    const taskDescription = $(task).find(".panel-body").html().trim();
    const editTemplate = JST['templates/tasks/edit'];
    const html = editTemplate({
      authenticity_token: window._token,
      task_id: task.attr("task_id"),
      description: taskDescription
    });
    $(taskBody).html(html);
    $(taskBody).find(".datepicker").datepicker();
  },
  updateUITask: function(task, response) {
    const template = JST['templates/tasks/show'];
    const dateOptions = { year: 'numeric', month: 'short', day: 'numeric' };
    const dueDate  = new Date(response.data.attributes.due);
    response.data.attributes["due"] = dueDate.toLocaleDateString("en-US", dateOptions);
    const html = template({
      task: response.data.attributes
    });
    $(task).replaceWith(html);
  },
  updateToggleCompletedUI: function(task) {
    $(task).toggleClass("completed");
    setTimeout( function() {
      task.hide();
    }, 1000);

  }
};
