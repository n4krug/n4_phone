$(function() {
    window.call = {}
    window.inDuty = null
    window.photos = []
    var totalSeconds = 0;
    var timer

    function display(bool) {
        if(bool) {
            $('.container').show()
            $('.container').removeClass('hidden');
        } else {
            $('.container').addClass('hidden');
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            window.settings = item.settings
            if (window.settings.do_not_disturb) {
                $('.right-nav .fa-bell-slash').css('display', 'unset')
            } else {
                $('.right-nav .fa-bell-slash').css('display', 'none')
            }

            window.contacts = item.contacts
            window.photos = item.photos
            window.phonenumber = item.userNumber
            window.personalnumber = item.personalnumber
            window.sms = item.sms
            window.job = item.job
            window.script = item.script
            display(item.status)
            addApps(item.apps)
            setQuickAcces(item.quickAcces)
            setDarkMode(item.settings.darkmode)
            setBackgroundImage(item.settings.bg_image)
        }
        if (item.type === "time") {
            var minute = item.time.minute
            if (minute < 10) {
                minute = `0${minute}`
            }
            var hour = item.time.hour
            if (hour < 10) {
                hour = `0${hour}`
            }
            $('.clock').html(`${hour}:${minute}`)
        }
        if (item.type === 'BankID') {
            window.settings = item.settings
            if (window.settings.do_not_disturb) {
                $('.right-nav fa-moon').css('display', 'unset')
            } else {
                $('.right-nav fa-moon').css('display', 'none')
            }

            window.contacts = item.contacts
            window.phonenumber = item.userNumber
            window.personalnumber = item.personalnumber
            window.sms = item.sms
            window.job = item.job
            display(true)
            addApps(item.apps)
            setQuickAcces(item.quickAcces)
            setDarkMode(item.settings.darkmode)
            setBackgroundImage(item.settings.bg_image)

            $.get('../apps/[bankid]/bankid.html', function (data) {
                $('#app-container').append(data)
                
                if (item.login === 'bank') {

                    $('#homepage').removeClass('active')
                    $('#app-container').addClass('active')

                    newBankIDAccept('Swedbank AB Inloggning', function() {
                        $.post('https://n4_bank/bankLoginSucces', JSON.stringify({}))
                        $('#app-container .bankid').remove()
                        $('#homepage').addClass('active')
                        $('#app-container').removeClass('active')
                        $.post(`https://${window.script}/exit`, JSON.stringify({}));
                    }, function() {
                        $('#homepage').addClass('active')
                        $('#app-container').removeClass('active')
                        $('#app-container .bankid').remove()
                    })
                }
                if (item.login === 'atm') {

                    $('#homepage').removeClass('active')
                    $('#app-container').addClass('active')

                    newBankIDAccept('Swedbank AB Inloggning', function() {
                        $.post('https://n4_bank/atmLoginSucces', JSON.stringify({}))
                        $('#app-container .bankid').remove()
                        $('#homepage').addClass('active')
                        $('#app-container').removeClass('active')
                        $.post(`https://${window.script}/exit`, JSON.stringify({}));
                    }, function() {
                        $('#homepage').addClass('active')
                        $('#app-container').removeClass('active')
                        $('#app-container .bankid').remove()
                    })
                }
            })
        }

        if (item.type == 'Call') {
            if (item.Function == 'Open') {
                window.call = item.Data

                $('.screen.active').removeClass('active')
                $('#call').addClass('active')
                
                $('.call-incomming').hide()
                $('.call-active').show()

                $('.caller-label').html(item.Data.CallerLabel)
                $('.call-info').html('Ringer..')
                clearInterval(timer)

                if (item.state == "InCall") {
                    totalSeconds = 0
                    timer = setInterval(setTime, 1000);
                }
            }
            if (item.Function == 'EndCall') {
                $('.screen.active').removeClass('active')
                $('#homepage').addClass('active')
                clearInterval(timer)
            }
            if (item.Function == "SetState") {
                if (item.state == "InCall") {
                    totalSeconds = 0
                    timer = setInterval(setTime, 1000);
                }
            }
        }
        if (item.type == 'Incomingcall') {
            if (item.Function == 'Open') {
                window.call = item.Data

                // display(true)
                totalSeconds = 0

                $('.screen.active').removeClass('active')
                $('#call').addClass('active')
                
                $('.call-active').hide()
                $('.call-incomming').show()

                $('.caller-label').html(item.Data.CallerLabel)
                $('.call-info').html('Ringer..')
            }
            if (item.Function == 'EndCall') {
                window.call = item.Data
                $('.screen.active').removeClass('active')
                $('#homepage').addClass('active')
                clearInterval(timer)
            }
        }
        if (item.type == 'JobPanel') {
            console.log(item.Data)
        }
    })


    function setTime() {
        ++totalSeconds;
        $('.call-info').html(pad(parseInt(totalSeconds / 60) + ":" + pad(totalSeconds % 60)))
    }

    function pad(val) {
        var valString = val + "";
        if (valString.length < 2) {
            return "0" + valString;
        } else {
            return valString;
        }
    }

    $('#cancel-call-btn').on('click', function() {
        $.post(`https://${window.script}/endCall`, JSON.stringify(window.call));
    })
    $('#dont-accept-call-btn').on('click', function() {
        $.post(`https://${window.script}/endCall`, JSON.stringify(window.call));
    })
    $('#accept-call-btn').on('click', function() {
        $.post(`https://${window.script}/joinCall`, JSON.stringify(window.call));
    })

    // ESC Close
    $(document).keyup(function(e) {
        if (e.key === "Escape") {
            $.post(`https://${window.script}/exit`, JSON.stringify({}));
        }
        if (e.key === "F1") {
            $.post(`https://${window.script}/exit`, JSON.stringify({}));
        }
    });

    function setDarkMode(mode) {
        if (mode == 1) {
            $('body').addClass('dark-mode')
        } else {
            $('body').removeClass('dark-mode')
        }
    }
    
    function setBackgroundImage(url) {
        $('.background').css('background-image', `url('${url}')`)
    }

    function addApps(apps) {
        app_list = $('.app-list')

        app_list.empty()

        apps.forEach((value)  => {
            
        
            app_list.append(`
                <div class="app" id="${value.label.toLowerCase().replace(/\s/g,'-')}">
                    <img src="../apps/[${value.file}]/${value.file}.webp" alt="${value.label}">
                    <p>${value.label}</p>
                </div>
            `)

            $(`#${value.label.toLowerCase().replace(/\s/g,'-')}`).on('click', function() {
                $('#app-container').empty()
                $('#homepage').removeClass('active')
                $('#app-container').addClass('active')
                $.get(`../apps/[${value.file}]/${value.file}.html`, function (data) {
                    $('#app-container').append(data)
                    $('#app-container').append('<div class="home-btn" id="home-btn"></div>')
                    $('#home-btn').on('click', function() {
                        $('#homepage').addClass('active')
                        $('#app-container').removeClass('active')
                        $('#app-container').empty()
                    })
                    nuiFocused = false
                    $('.input').focus(function() {
                        if (!nuiFocused) {
                            nuiFocused = true
                            $.post(`https://${window.script}/setNuiFocus`, JSON.stringify({focus: true}));
                        }
                    })
                    $('.input').parent().focusout(function() {
                        if (nuiFocused) {
                            nuiFocused = false
                            $.post(`https://${window.script}/setNuiFocus`, JSON.stringify({focus: false}));
                        }
                    })
                })
            })
        })
    }

    function setQuickAcces(apps) {
        app_list = $('.quick-access')

        app_list.empty()

        apps.forEach((value)  => {

        
            app_list.append(`
                <div class="app" id="${value.label.toLowerCase().replace(/\s/g,'-')}">
                    <img src="../apps/[${value.file}]/${value.file}.webp" alt="${value.label}">
                </div>
            `)

            $(`#${value.label.toLowerCase().replace(/\s/g,'-')}`).on('click', function() {
                $('#app-container').empty()
                $('#homepage').removeClass('active')
                $('#app-container').addClass('active')
                $.get(`../apps/[${value.file}]/${value.file}.html`, function (data) {
                    $('#app-container').append(data)
                    $('#app-container').append('<div class="home-btn" id="home-btn"></div>')
                    $('#home-btn').on('click', function() {
                        if ($(':root').has('.camera-container').length > 0) {
                            fetch(`https://${window.script}/camApp`, {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json; charset=UTF-8',
                                },
                                body: JSON.stringify({open: false})
                            })
                        }

                        $('#homepage').addClass('active')
                        $('#app-container').removeClass('active')
                        $('#app-container').empty()
                    })
                    nuiFocused = false
                    $('.input').focus(function() {
                        if (!nuiFocused) {
                            nuiFocused = true
                            $.post(`https://${window.script}/setNuiFocus`, JSON.stringify({focus: true}));
                        }
                    })
                    $('.input').parent().focusout(function() {
                        if (nuiFocused) {
                            nuiFocused = false
                            $.post(`https://${window.script}/setNuiFocus`, JSON.stringify({focus: false}));
                        }
                    })
                })
            })
        })
    }
})

function QuickSetting(type, elem) {
    var state = false
    if (type == 'flash') {
        state = $(elem).children('i').hasClass('fa-regular')
        $(elem).children('i').toggleClass('fa-regular', !state).toggleClass('fa-solid', state)
    } else if (type == 'darkmode') {
        state = $(elem).children('i').hasClass('fa-moon')
        $(elem).children('i').toggleClass('fa-sun', state).toggleClass('fa-moon', !state)

        $('body').toggleClass('dark-mode', !state)
        window.settings.darkmode = state ? 0 : 1
        $.post(`https://${window.script}/saveSettings`, JSON.stringify(window.settings))
    } else if (type == 'dnd') {
        state = $(elem).children('i').hasClass('fa-bell')
        $(elem).children('i').toggleClass('fa-bell', !state).toggleClass('fa-bell-slash', state)

        $('.right-nav .fa-bell-slash').css('display', state ? 'unset' : 'none')
        window.settings.do_not_disturb = state ? 1 : 0
        $.post(`https://${window.script}/saveSettings`, JSON.stringify(window.settings))
    }
    $(elem).toggleClass('active', state)
    // console.log(type)
    // console.log($(elem).children('i').hasClass('fa-solid'))
    $.post(`https://${window.script}/quicksettingToggled`, JSON.stringify({type: type, state: state}));
}

function ShowQuickSettings(state) {
    if (typeof(state) == 'boolean') {
        $('.quick-settings-container').toggleClass('active', state)
    } else if (state == 'toggle') {
        $('.quick-settings-container').toggleClass('active')
    }
    // console.log(window.settings.darkmode)
    // console.log(window.settings.darkmode == 1 || false)
    $('#quick-dnd i').toggleClass('fa-bell-slash', window.settings.do_not_disturb == 1 || false).toggleClass('fa-bell', !(window.settings.do_not_disturb == 1 || false))
    $('#quick-dnd').toggleClass('active', window.settings.do_not_disturb == 1 || false)
    $('#quick-darkmode i').toggleClass('fa-moon', window.settings.darkmode == 1 || false).toggleClass('fa-sun', !(window.settings.darkmode == 1 || false))
    $('#quick-darkmode').toggleClass('active', !(window.settings.darkmode == 1 || false))
}