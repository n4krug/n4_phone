let Posts = []

function newPost() {
    // console.log("new post")
    const text = $("#chirp-newpost").val();
    $("#chirp-newpost").val("");
    if (text == "" || text == null) {
        return;
    }

    const post = {
        text: text,
        id: Math.floor(Math.random() * 1000000000),
    }

    $.post(`https://${window.script}/addChirpPost`, JSON.stringify(post)).then((data) => {
        addPostToFeed(data);
        Posts.push(data);
    });
}

function deletePost(id) {
    $.post(`https://${window.script}/deleteChirpPost`, JSON.stringify({id: id})).then(() => {
        $(`.post#${id}`).remove();
    });
}

function LikePost(id) {
    $.post(`https://${window.script}/likeChirpPost`, JSON.stringify({id: id})).then((data) => {
        // console.log(data);
        $(`.post#${id} .chirp-like-count`).html(data.likes);
        $(`.post#${id} .chirp-like-btn i`).removeClass("fa-solid fa-regular").addClass(`fa-${data.liked ? "solid" : "regular"}`);
    });
}

function addPostToFeed(post) {
    var photoRegex = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|]).(?:jpg|gif|png)/ig;
    const postEl = $(`
        <div class="post" id="${post.id}">
            ${post.personalnumber == window.personalnumber ? `<button class="chirp-post-delete blue-btn circle" onclick="deletePost(${post.id})">
                <i class="fa-solid fa-trash"></i>
            </button>` : ""}
            <div class="chirp-post-header">
                <p class="chirp-post-name">
                    ${post.name}
                </p>
                <p class="chirp-post-username">
                    @${post.username}
                </p>
            </div>
            <p class="chirp-post-text">
                ${post.text.replace(photoRegex, `<img src="$&" alt="">`)}
            </p>
            <div class="chirp-post-footer">
            <button class="chirp-like-btn chirp-action-btn" onclick="LikePost(${post.id})">
                <i class="fa-${post.liked ? "solid" : "regular"} fa-heart"></i>
                <p class="chirp-like-count">${post.likes}</p>
            </button>
            <button class="chirp-retweet-btn chirp-action-btn">
                <i class="fa-solid fa-rotate"></i>
            </button>
            </div>
        </div>
    `);

    $("#chirp-feed").prepend(postEl);

    $(`#${post.id} img`).on('mousedown', function(){
        $('#big-image').attr('src', $(this).attr('src'))
    }).on('mouseup', function(){
        $('#big-image').attr('src', "")
    })
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
    $("#chirp-feed").html("");
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
    $("#chirp-newpost-btn").on("click", newPost);
    // $("#chirp-newpost").on("keyup", function (e) {
    //     if (e.key == "Enter") {
    //         newPost();
    //     }
    // });

    $("#chirp-search").on("keyup", function (e) {
        searchPosts($("#chirp-search").val());
    });

    $.post(`https://${window.script}/getChirpPosts`, JSON.stringify({})).then((data) => {
        Posts = [...data];
        for (const post of data) {
            addPostToFeed(post);
        }
    });
});