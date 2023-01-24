$(function() {

    $('.notification-container').empty()

    window.addEventListener('message', function(event) {
        var item = event.data;
        

        if(item.type == 'notification') {
            if($('#phone').hasClass('hidden')) {
                $('#phone').addClass('message')
            }
            
            $('.notification-container').append(`
                <div class="notification" id="${item.id}">
                    <img src="images/apps/${item.app}.webp" alt="" class="notification-icon" />
                    <h3 class="notification-title">${item.title}</h3>
                    <p class="notification-message">${item.message}<p>
                </div>
            `)
            
        // app = 'sms',
        // title = 'SMS - Testing AB',
        // message = 'Yes, This is a test message we are testing very hard right now. testing testing testing.',
        // id = 'test'

            $(`#${item.id}`).one('animationend', function() {
                $(`#${item.id}`).remove()
                $('#phone').removeClass('message')
            })

            $(`#${item.id}`).on('click', function() {
                $.when(openApp(item.app)).then(function() {
                    // notification(item.onClick)
                    // if(item.app == 'sms') {
                    //     $('#app-container').addClass('fromNotif')
                    // }
                })
            })
        } else if (item.type == 'call') {
            openApp('call')
        }
    })

    function openApp(appName) {
        $('#app-container').empty()
                $('#homepage').removeClass('active')
                $('#app-container').addClass('active')
                $.get(`apps/${appName}.html`, function (data) {
                    // $('#app-container').append(
                    //     `<div class="navbar">
                    //         <div class="left-nav">
                    //             <p class="clock" id="time">21:20</p>
                    //         </div>
                    //         <div class="right-nav">
                    //             <i class="fa-solid fa-signal"></i>
                    //             <i class="fa-solid fa-wifi"></i>
                    //             <i class="fa-solid fa-battery-full"></i>
                    //         </div>
                    //     </div>
                    // `)
                    $('#app-container').append(data)
                    $('#app-container').append('<div class="home-btn" id="home-btn"></div>')
                    $('#home-btn').on('click', function() {
                        $('#homepage').addClass('active')
                        $('#app-container').removeClass('active')
                        $('#app-container').empty()
                    })
                })
    }
})