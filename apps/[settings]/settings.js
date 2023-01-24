$(function() {
    $.post(`https://${window.script}/getSettingCategories`, JSON.stringify({}), function(data) {
        const {categories} = data

        for (let i = 0; i < categories.length; i++) {// (const category of data) {
            const category = categories[i]
            let categoryHtml = $(`<div class="setting-div darkmode-div">
            <div class="setting-title">
                <p>${category.title}</p>
            </div>
            `)

            for (let j = 0; j < category.Settings.length; j++) {// (const setting of category.Settings) {
                const setting = category.Settings[j]
                let settingHTML = $(`
                <div class="setting-row">
                    <p>${setting.title}</p>
                    ${
                        setting.type == 'toggle'
                        ?   `<label class="switch">
                                <input type="checkbox" onchange="SettingChanged(${i}, ${j}, this)" ${setting.state ? 'checked' : ''}/>
                                <span class="slider"></span>
                            </label>` 
                        : ""
                    }
                </div>
                `)
                categoryHtml.append(settingHTML)
            }
            categoryHtml.append('</div>')
            $('#settings-container').append(categoryHtml)
        }
        
    })
    $('#bg-url-inp').val(window.settings.bg_image)
    $('#user-number').html(window.phonenumber)
    $('#user-personalnumber').html(window.personalnumber)
    for(const [blip, status] of Object.entries(window.settings.blips)) {
        $(`#${blip}-blip`).prop("checked", status)
    }
    if (window.settings.darkmode == 1) {
        $('#darkmode-switch').prop( "checked", true )
    }
    if (window.settings.do_not_disturb == 1) {
        $('#dnd-switch').prop( "checked", true )
    }
    
    $('#darkmode-switch').change(function() {
        if ($('#darkmode-switch')[0].checked) {
            window.settings.darkmode = 1
        } else {
            window.settings.darkmode = 0
        }
        setDarkMode(window.settings.darkmode)
        $.post(`https://${window.script}/saveSettings`, JSON.stringify(window.settings))
    })
    $('#dnd-switch').change(function() {
        if ($('#dnd-switch')[0].checked) {
            window.settings.do_not_disturb = 1
            $('.right-nav .fa-bell-slash').css('display', 'unset')
        } else {
            $('.right-nav .fa-bell-slash').css('display', 'none')
            window.settings.do_not_disturb = 0
        }
        $.post(`https://${window.script}/saveSettings`, JSON.stringify(window.settings))
    })
    
    $('#bg-url-inp').change(function() {
        window.settings.bg_image = $('#bg-url-inp').val()
    })

    setTimeout(() => {
        $('#home-btn').on('click', function() {
            $.post(`https://${window.script}/saveSettings`, JSON.stringify(window.settings))
            setBackgroundImage(window.settings.bg_image)
        })
    }, 100)

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

    $('.blip-switch').change(function() {
        window.settings.blips[$(this).attr('id').split('-')[0]] = $(this)[0].checked
        $.post(`https://${window.script}/saveSettings`, JSON.stringify(window.settings))
    })

})

function SettingChanged(category, setting, element) {
    // data[category][setting].func(element.checked)
    $.post(`https://${window.script}/settingChanged`, JSON.stringify({category, setting, value: element.checked}))
}
