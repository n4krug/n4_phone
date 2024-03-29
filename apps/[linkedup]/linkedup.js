let Posts = []

function newPost() {
    const text = $("#linkedup-newpost").val();
    $("#linkedup-newpost").val("");
    if (text == "" || text == null) {
        return;
    }

    const post = {
        text: text,
        id: Math.floor(Math.random() * 1000000000),
    }

    $.post(`https://${window.script}/addLinkedUpPost`, JSON.stringify(post)).then((data) => {
        addPostToFeed(data);
        Posts.push(data);
    });
}

function deletePost(id) {
    $.post(`https://${window.script}/deleteLinkedUpPost`, JSON.stringify({id: id})).then(() => {
        $(`.post#${id}`).remove();
    });
}

function addPostToFeed(post) {
    const postEl = $(`
        <div class="post" data-personalnumber="${post.personalnumber}" id="${post.id}">
            ${post.personalnumber == window.personalnumber ? `<button class="linkedup-post-delete blue-btn" onclick="deletePost(${post.id})">
                <i class="fa-solid fa-trash"></i>
            </button>` : ""}
            <p class="linkedup-post-title">
                ${post.name}
            </p>
            <p class="linkedup-post-text">
                ${post.text}
            </p>
            <button class="linkedup-post-call blue-btn x-btn-pad" onclick="CopyText('${post.number}')">
            <i class="fa-solid fa-clipboard"></i>   ${formatPhoneNumber(post.number)}
            </button>
        </div>
    `);

    $("#linkedup-feed").prepend(postEl);
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
    $("#linkedup-feed").html("");
    for (const post of Posts) {
        if (post.text.toLowerCase().includes(searchString.toLowerCase()) || post.name.toLowerCase().includes(searchString.toLowerCase())) {
            addPostToFeed(post);
        }
    }
}

function CopyText(coords) {
    console.log(coords)
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
    $("#linkedup-newpost-btn").on("click", newPost);
    $("#linkedup-newpost").on("keyup", function (e) {
        if (e.key == "Enter") {
            newPost();
        }
    });

    $("#linkedup-search").on("keyup", function (e) {
        searchPosts($("#linkedup-search").val());
    });

    $.post(`https://${window.script}/getLinkedUpPosts`, JSON.stringify({})).then((data) => {
        Posts = [...data];
        for (const post of data) {
            addPostToFeed(post);
        }
    });
});