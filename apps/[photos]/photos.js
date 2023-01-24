$(function(){
    window.photos.forEach(photo => {
        $('#photo-list').prepend(`<img src="${photo.Url}" alt="" class="photo">`)
    });

    $('.photo').on('click', function(){
        CopyText($(this).attr('src'))
    })
    $('.photo').on('mousedown', function(){
        $('#big-image').attr('src', $(this).attr('src'))
    }).on('mouseup', function(){
        $('#big-image').attr('src', "")
    })
})

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