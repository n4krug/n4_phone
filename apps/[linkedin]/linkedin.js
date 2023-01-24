let Posts = []

function newPost() {
    const text = $("#linkedin-newpost").val();
    $("#linkedin-newpost").val("");
    if (text == "" || text == null) {
        return;
    }

    const post = {
        text: text,
        id: Math.floor(Math.random() * 1000000000),
    }

    $.post(`https://${window.script}/addLinkedInPost`, JSON.stringify(post)).then((data) => {
        addPostToFeed(data);
        Posts.push(data);
    });
}

function deletePost(id) {
    $.post(`https://${window.script}/deleteLinkedInPost`, JSON.stringify({id: id})).then(() => {
        $(`.post#${id}`).remove();
    });
}

function addPostToFeed(post) {
    const postEl = $(`
        <div class="post" data-personalnumber="${post.personalnumber}" id="${post.id}">
            ${post.personalnumber == window.personalnumber ? `<button class="linkedin-post-delete blue-btn" onclick="deletePost(${post.id})">
                <i class="fa-solid fa-trash"></i>
            </button>` : ""}
            <p class="linkedin-post-title">
                ${post.name}
            </p>
            <p class="linkedin-post-text">
                ${post.text}
            </p>
            <button class="linkedin-post-call blue-btn x-btn-pad" onclick="CopyText(${post.number})">
            <i class="fa-solid fa-clipboard"></i>   ${formatPhoneNumber(post.number)}
            </button>
        </div>
    `);

    $("#linkedin-feed").prepend(postEl);
}

function callNumber(number) {
    console.log(number);
}

function formatPhoneNumber(phoneNumberString) {
    var cleaned = ('' + phoneNumberString).replace(/\D/g, '');
    var match = cleaned.match(/^(\d{3})(\d{3})(\d{2})(\d{2})$/);
    if (match) {
      return match[1] + ' - ' + match[2] + ' ' + match[3] + ' ' + match[4];
    }
    return null;
}

function searchPosts(searchString) {
    $("#linkedin-feed").html("");
    for (const post of Posts) {
        if (post.text.toLowerCase().includes(searchString.toLowerCase()) || post.name.toLowerCase().includes(searchString.toLowerCase())) {
            addPostToFeed(post);
        }
    }
}

function CopyText(coords) {
    var text = document.createElement('textarea');
    text.value = coords;
    text.setAttribute('readonly', '');
    text.style = {position: 'absolute', left: '-9999px'};
    document.body.appendChild(text);
    text.select();
    document.execCommand('copy');
    document.body.removeChild(text);
}

$(function () {
    $("#linkedin-newpost-btn").on("click", newPost);
    $("#linkedin-newpost").on("keyup", function (e) {
        if (e.key == "Enter") {
            newPost();
        }
    });

    $("#linkedin-search").on("keyup", function (e) {
        searchPosts($("#linkedin-search").val());
    });

    $.post(`https://${window.script}/getLinkedInPosts`, JSON.stringify({})).then((data) => {
        Posts = [...data];
        for (const post of data) {
            addPostToFeed(post);
        }
    });
});