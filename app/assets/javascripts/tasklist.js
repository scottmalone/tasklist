const tasklist = {
  setup: function() {
    tasklist.bindNewTask();
  },
  bindNewTask: function() {
    $("#new-task-container").on("submit", "#new-task-form", function (e) {
      var form = $(this);
      var url = form.attr('action');

      $.ajax({
        type: "POST",
        url: url,
        data: form.serialize(),
        success: function(response) {
          tasklist.addNewTask(response);
          tasklist.removeNewTaskForm();
        }
      });

      e.preventDefault();
    });

    $("#new-task-link").click(function() {
      tasklist.getNewTaskForm(this);
      return false;
    });
  },
  getNewTaskForm: function(link) {
    var newTemplate = JST['templates/tasks/new'];
    var html = newTemplate({
      authenticity_token: window._token
    });
    $("#new-task-container").append(html);
  },
  removeNewTaskForm: function() {
    $("#new-task-container").empty();
  },
  addNewTask: function(response) {
    const template = JST['templates/tasks/show'];
    const dateOptions = { year: 'numeric', month: 'short', day: 'numeric' };
    const dueDate  = new Date(response.data.attributes.due);
    response.data.attributes["due"] = dueDate.toLocaleDateString("en-US", dateOptions);
    const html = template({
      task: response.data.attributes
    });
    $(".panel-group").prepend(html);
  }
};
