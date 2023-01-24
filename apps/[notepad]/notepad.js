Notes = []
$(function() {
    LoadNotes()
})

function LoadNotes() {
    $.post(`https://${window.script}/getNotes`, JSON.stringify({})).then((data) => {
        Notes = data

        AppendNotes(data)
    })
}

function SearchNotes() {
    var search = $("#notes-search").val().toLowerCase()

    var filteredNotes = Notes.filter((note) => {
        return note.title.toLowerCase().includes(search) || note.content.toLowerCase().includes(search)
    })

    AppendNotes(filteredNotes)
}

function AppendNotes(data) {
    data.sort((a, b) => b.editedDate - a.editedDate)

    $("#notes-list").html("")
    data.forEach((note) => {
        $("#notes-list").append(`<div class="note" onclick="OpenNote('${note.id}')">
            <div class="note-title">${note.title}</div>
            <div class="note-time">${timeSince(note.editedDate)}</div>
        </div>`)
    })
}

function OpenNote(id) {
    var note = Notes.find(o => o.id == id)

    $("#note-edit-page").attr("data-id", note.id)
    $("#note-edit-title").val(note.title)
    $("#note-edit-content").val(note.content)

    // $("#notes-page").hide()
    $("#note-edit-page").addClass('active')
}

function SaveNote() {
    var note = {}
    note.id = $("#note-edit-page").attr("data-id") || Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
    note.title = $("#note-edit-title").val()
    note.content = $("#note-edit-content").val()
    note.editedDate = new Date().getTime()

    if (note.title == "") {
        note.title = "Untitled"
    }

    var noteId = Notes.findIndex(o => o.id == note.id)

    noteId > -1 ? Notes[noteId] = note : Notes.push(note)

    $.post(`https://${window.script}/saveNotes`, JSON.stringify(Notes)).then((data) => {
        Notes = data

        AppendNotes(data)

        $("#note-edit-page").removeClass('active')
        $("#note-edit-page").removeAttr("data-id")
    })
}

function timeSince(date) {

    var seconds = Math.floor((new Date() - date) / 1000);
  
    var interval = seconds / 31536000;
    if (interval > 1) {
        return Math.floor(interval) + " år sedan";
    }
    interval = seconds / 2592000;
    if (interval > 1) {
        return Math.floor(interval) + " månader sedan";
    }
    interval = seconds / 86400;
    if (interval > 1) {
        return Math.floor(interval) + " dagar sedan";
    }
    interval = seconds / 3600;
    if (interval > 1) {
        return Math.floor(interval) + " timmar sedan";
    }
    interval = seconds / 60;
    if (interval > 1) {
        return Math.floor(interval) + " minuter sedan";
    }
    return Math.floor(seconds) + " sekunder sedan";
}
  