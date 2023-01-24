let Posts = []

function newPost() {
    const text = $("#twitter-newpost").val();
    $("#twitter-newpost").val("");
    if (text == "" || text == null) {
        return;
    }

    const post = {
        text: text,
        id: Math.floor(Math.random() * 1000000000),
    }

    $.post(`https://${window.script}/addTwitterPost`, JSON.stringify(post)).then((data) => {
        addPostToFeed(data);
        Posts.push(data);
    });
}

function deletePost(id) {
    $.post(`https://${window.script}/deleteTwitterPost`, JSON.stringify({id: id})).then(() => {
        $(`.post#${id}`).remove();
    });
}

function LikePost(id) {
    $.post(`https://${window.script}/likeTwitterPost`, JSON.stringify({id: id})).then((data) => {
        console.log(data);
        $(`.post#${id} .twitter-like-count`).html(data.likes);
        $(`.post#${id} .twitter-like-btn i`).removeClass("fa-solid fa-regular").addClass(`fa-${data.liked ? "solid" : "regular"}`);
    });
}

function addPostToFeed(post) {
    var photoRegex = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|]).(?:jpg|gif|png)/ig;
    const postEl = $(`
        <div class="post" id="${post.id}">
            ${post.personalnumber == window.personalnumber ? `<button class="twitter-post-delete blue-btn circle" onclick="deletePost(${post.id})">
                <i class="fa-solid fa-trash"></i>
            </button>` : ""}
            <div class="twitter-post-header">
                <p class="twitter-post-name">
                    ${post.name}
                </p>
                <p class="twitter-post-username">
                    @${post.username}
                </p>
            </div>
            <p class="twitter-post-text">
                ${post.text.replace(photoRegex, `<img src="$&" alt="">`)}
            </p>
            <div class="twitter-post-footer">
            <button class="twitter-like-btn twitter-action-btn" onclick="LikePost(${post.id})">
                <i class="fa-${post.liked ? "solid" : "regular"} fa-heart"></i>
                <p class="twitter-like-count">${post.likes}</p>
            </button>
            <button class="twitter-retweet-btn twitter-action-btn">
                <i class="fa-solid fa-rotate"></i>
            </button>
            </div>
        </div>
    `);

    $("#twitter-feed").prepend(postEl);

    $(`#${post.id} img`).on('mousedown', function(){
        $('#big-image').attr('src', $(this).attr('src'))
    }).on('mouseup', function(){
        $('#big-image').attr('src', "")
    })
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
    $("#twitter-feed").html("");
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
    $("#twitter-newpost-btn").on("click", newPost);
    // $("#twitter-newpost").on("keyup", function (e) {
    //     if (e.key == "Enter") {
    //         newPost();
    //     }
    // });

    $("#twitter-search").on("keyup", function (e) {
        searchPosts($("#twitter-search").val());
    });

    $.post(`https://${window.script}/getTwitterPosts`, JSON.stringify({})).then((data) => {
        Posts = [...data];
        for (const post of data) {
            addPostToFeed(post);
        }
    });
});