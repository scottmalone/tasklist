const tasklist = {
  setup: function() {
    tasklist.setLocalizedDates();
    tasklist.bindNewTask();
    tasklist.bindEditTask();
    tasklist.bindToggleCompleted();
    tasklist.bindShowCompletedCheckbox();
    tasklist.activateSortable();
    tasklist.bindDeleteTask();
    tasklist.bindUploadAttachment();
    tasklist.bindDeleteAttachment();
  },

  setLocalizedDates: function() {
    $(".task").each(function() {
      tasklist.setLocalizedDate($(this));
    });
  },

  setLocalizedDate: function(task) {
    const currentDueDate = $(task).attr("due");
    const formattedDueDate = tasklist.localizedDate(currentDueDate);
    $(task).find(".localized-due-date").html(formattedDueDate);
  },

  localizedDate: function(date) {
    const localizedDueDate = new Date(date);
    const options = { year: 'numeric', month: 'short', day: 'numeric' };
    return localizedDueDate.toLocaleDateString('en-US', options);
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
      const link = $(this);
      const task = $(link).closest(".task");
      if(!$(".task .edit-task-form").length) {
        tasklist.getEditTaskForm(this);
        const currentDueDate = $(task).attr("due");
        const localizedDueDate = new Date(currentDueDate);
        $(".task .datepicker").datepicker('setDate', localizedDueDate);
      }
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

  bindDeleteTask: function() {
    $(".panel-group").on("click", ".delete-task-link", function (e) {
      const link = $(this);
      const task = $(link).closest(".task");
      const taskID = $(task).attr("task_id");
      const url = `/api/tasks/${taskID}`;
      $.ajax({
        type: "DELETE",
        url: url,
        success: function(response) {
          tasklist.decrementPositionsAfterItem(task);
          task.remove();
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

      e.preventDefault();
    });
  },

  bindUploadAttachment: function() {
    $(".panel-group").on("click", ".upload-attachment-link", function (e) {
      const link = $(this);
      const task = $(link).closest(".task");
      const taskID = $(task).attr("task_id");
      if(!$(".task .new-attachment-form").length) {
        tasklist.getUploadAttachmentForm(this);
      }

      e.preventDefault();
    });

    $(".panel-group").on("submit", ".new-attachment-form", function (e) {
      const form = $(this);
      const url = form.attr('action');
      const task = $(form).closest(".task");

      $.ajax({
        type: "POST",
        url: url,
        data: new FormData(this),
        contentType: false,
        cache: false,
        processData:false,
        success: function(response) {
          tasklist.getUploadAttachmentForm(form);
          tasklist.updateUIAttachment(task, response);
        }
      });

      e.preventDefault();
    });
  },

  bindDeleteAttachment: function() {
    $(".panel-group").on("click", ".delete-attachment-link", function (e) {
      const link = $(this);
      const attachment = $(link).closest(".attachment");
      const attachmentID = $(attachment).attr("attachment_id");
      const url = `/api/attachments/${attachmentID}`;

      $.ajax({
        type: "DELETE",
        url: url,
        success: function(response) {
          $(attachment).remove();
        }
      });

      e.preventDefault();
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
    const formattedDueDate = tasklist.localizedDate(response.data.attributes.due);
    response.data.attributes["due"] = formattedDueDate;
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

  getUploadAttachmentForm: function(obj) {
    const task = $(obj).closest(".task");
    const taskFooter = $(task).find(".panel-footer");
    const newAttachmentTemplate = JST['templates/attachments/new'];
    const html = newAttachmentTemplate({
      authenticity_token: window._token,
      task_id: task.attr("task_id")
    });
    $(task).find(".new-attachment-form").remove();
    $(taskFooter).prepend(html);
    $(taskFooter).removeClass("invisible");
  },

  updateUITask: function(task, response) {
    const template = JST['templates/tasks/show'];
    const html = template({
      task: response.data.attributes
    });
    $(task).replaceWith(html);
    task = $(".task[task_id='" + response.data.attributes.id + "']")
    tasklist.setLocalizedDate(task);
  },

  updateUIAttachment: function(task, response) {
    const template = JST['templates/attachments/show'];
    const html = template({
      attachment: response.data.attributes
    });
    $(task).find(".attachments").append(html);
  },

  updateToggleCompletedUI: function(task) {
    $(task).toggleClass("completed");
    if($(task).hasClass("completed")) {
      $(task).toggleClass("panel-primary panel-success");
    } else {
      $(task).toggleClass("panel-success panel-primary");
    };
    if($(task).hasClass("completed") && !tasklist.isShowCompletedChecked()) {
      setTimeout( function() {
        task.hide();
      }, 500);
    };
  },

  isShowCompletedChecked: function() {
    return $("#show-completed-checkbox:checked").length > 0;
  },

  bindShowCompletedCheckbox: function() {
    $("#show-completed-checkbox").change(function() {
      if(this.checked) {
        $(".task").show();
      } else {
        $(".task.completed").hide();
      }
    });
  },

  activateSortable: function() {
    $("#task-container").sortable({
      start: function(event, ui) {
        ui.item.startIndex = ui.item.index();
      },
      stop: function(event, ui) {
        const currentPosition = parseInt(ui.item.attr("position"));
        const positionChange =  ui.item.index() - ui.item.startIndex;
        const newPosition = currentPosition + positionChange;
        const taskItem = ui.item[0];
        tasklist.updateTaskPosition(taskItem, newPosition).then(function(result) {
          tasklist.repositionItem($(taskItem), result.data.attributes.position);
        });
      },
      axis: "y"
    });
  },

  updateTaskPosition: function(taskItem, taskPosition) {
    const taskId = taskItem.attributes.task_id.value;
    const url = '/api/tasks/' + taskId;
    const data = $.param({ task: { position: taskPosition }});
    return $.ajax({
      url: url,
      type: 'PUT',
      data: data
    }).fail(function() {
      $("#task-container").sortable("cancel");
    });
  },

  repositionItem: function(taskItem, position) {
    taskItem.attr('position', position);
    taskItem.removeAttr('style');
    const previousItems = taskItem.prevAll();
    const nextItems = taskItem.nextAll();
    const previousItemsLength = previousItems.length ;
    const nextItemsLength = nextItems.length;
    var itemPosition;
    previousItems.each(function(i, item) {
      itemPosition = position - i - 1;
      $(item).attr('position', itemPosition);
    });
    nextItems.each(function(i, item) {
      itemPosition = position + i + 1;
      $(item).attr('position', itemPosition);
    });
  },

  decrementPositionsAfterItem: function(task) {
    const nextItems = task.nextAll();
    var itemPosition;
    nextItems.each(function(i, item) {
      itemPosition = parseInt($(item).attr("position")) - 1;
      $(item).attr('position', itemPosition);
    });
  }
};
