//draw the image on first load
// cropImage(imagePath, 0, 0, 200, 200);

const webhook = 'https://discord.com/api/webhooks/1063180310122078269/zoXe2oC5sAaDdLzKScUIceg_safbgAbaQPgabSxB-Qa6ac7s54uJ3cJpk-EJt9ham1Hr';

const imgur_url = 'https://api.imgur.com/3/image'
const imgur_client_id = 'feecefc47392dc3'
const imgur_client_secret = '535df4dc821f5c273fb395c5c7e1259d1b953ffe'

//crop the image and draw it to the canvas
function cropImage(imagePath, newX, newY, newWidth, newHeight, cb) {
    //create an image object from the path
    const originalImage = new Image();
    originalImage.src = imagePath;
 
    //initialize the canvas object
    const canvas = document.getElementById('canvas'); 
    const ctx = canvas.getContext('2d');
 
    ctx.clearRect(0, 0, canvas.width, canvas.height)
    //wait for the image to finish loading
    originalImage.addEventListener('load', function() {
 
        //set the canvas size to the new width and height
        canvas.width = newWidth;
        canvas.height = newHeight;
         
        //draw the image
        ctx.drawImage(originalImage, newX, newY, newWidth, newHeight, 0, 0, newWidth, newHeight); 
    
        cb(document.getElementById('canvas').toDataURL("image/jpeg", 0.9))
    });
}

function rem(rem) {
    return rem * parseFloat(getComputedStyle(document.documentElement).fontSize);
}

const getFormData = (imgData) => {
    const formData = new FormData();
    formData.append('image', dataURItoBlob(imgData), `screenshot.jpg`);
    formData.append('files[]', dataURItoBlob(imgData), `screenshot.jpg`);
    formData.append('type', 'URL')
    return formData;
};

function dataURItoBlob(dataURI) {
    const byteString = atob(dataURI.split(',')[1]);
    const mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]

    const ab = new ArrayBuffer(byteString.length);
    const ia = new Uint8Array(ab);
  
    for (let i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }
  
    const blob = new Blob([ab], {type: mimeString});
    return blob;
}

// upload the image somewhere


$(function() {
    fetch(`https://${window.script}/camApp`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({open: true})
    })


    $('#camera-screen-flip').on('click', function(){
        $('.camera-container').toggleClass('landscape')
    })

    $('#camera-shutter').on('click', function(){
        const bounding_rect = $('#cam-canvas').get()[0].getBoundingClientRect()
        selfie = !selfie
        fetch(`https://${window.script}/camCapture`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                // landscape: $('.camera-container').hasClass('landscape')
                x: bounding_rect.x,
                y: bounding_rect.y,
                width: bounding_rect.width,
                height: bounding_rect.height,
            })
        })
    })

    var selfie = false
    $('#camera-flip').on('click', function(){
        selfie = !selfie
        fetch(`https://${window.script}/selfieCam`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({selfie: selfie})
        })
    })

    $('#cam-canvas').on('mousedown',function(){
        fetch(`https://${window.script}/mouseMove`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({state: true})
        })
        // $(':root').addClass('hideCursor')
        $(':root').one('mouseup',function(){
            fetch(`https://${window.script}/mouseMove`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({state: false})
            })
            // $(':root').removeClass('hideCursor')
            // document.exitPointerLock();
        })
    })

    window.addEventListener('message', function(event) {
        const item = event.data

        if (item.type == 'photoTaken') {
            const {x, y, width, height} = item.rect
            // const x = item.landscape ? rem(25) : rem(52)
            // const y = item.landscape ? rem(10) : rem(10)
            // const width = item.landscape ? rem(80) : rem(40)
            // const height = item.landscape ? rem(50) : rem(55)
            cropImage(item.imgData, x, y, width, height, function(imgData){
                // fetch(webhook, {
                //     method: 'POST',
                //     mode: 'cors',
                //     headers: {},
                //     body: getFormData(imgData)
                // }).then(response => response.json())
                // fetch(imgur_url, {
                //     method: 'POST',
                //     // mode: 'cors',
                //     headers: {
                //         'Authorization': `Client-ID ${imgur_client_id}`,
                //         'Content-Type': 'multipart/form-data',
                //     },
                //     body: getFormData(imgData)
                // }).then(response => response.json())
                // .then(data => {
                $.ajax({
                        url: imgur_url,
                        type: "POST",
                        datatype: "json",
                        headers: {
                          "Authorization": "Client-ID " + imgur_client_id
                        },
                        data: getFormData(imgData),
                        success: function(response) {
                            const data = response.data
                            $('.camera-container').append(`<img src=${data.link} alt="" class="preview-photo">`)
        
                            $(`.preview-photo`).one('animationend', function() {
                                $(`.preview-photo`).remove()
                            })
        
                            fetch(`https://${window.script}/imgCropped`, {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json; charset=UTF-8',
                                },
                                body: JSON.stringify({ imgUrl: data.link, timestamp: Date.now() })
                            }).then(response => response.json()).then(data => {
                                window.photos = data.photos
                            })
                        },
                        cache: false,
                        contentType: false,
                        processData: false
                    });
                // })
            })
        }
    })
})