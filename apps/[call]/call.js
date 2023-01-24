$(function() {
    $('.number-btn').on('click', function() {
        $('.number-input').val($('.number-input').val() + $(this).val())
    })

    $('#call-btn').on('click', function() {
        fetch(`https://${window.script}/createCall`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                Number: $('#number-input').val(),
                Caller: window.phonenumber,
                HiddenNumber: false,
            })
        })
    })

    function switchPage(page) {
        $('.call-page').removeClass('active')
        $(`#${page}`).addClass('active')
        $('.call-nav-btn').removeClass('active')
        $(`#${page}-btn`).addClass('active')
    }

    $('#call-keypad-btn').on('click', function() {switchPage('keypad-page')})
    $('#call-contacts-btn').on('click', function() {
        switchPage('contacts-page') 
        updateContactList('')
    })

    $('#contact-search').keyup(function() {
        updateContactList($('#contact-search').val())
    })
    
    function updateContactList(searchString) {
        // $('.contact-title').html(searchString)
        let contacts = window.contacts
        $('.contact-list').empty()

        contacts.sort((obj1, obj2) => {
            const o1 = obj1['Name'].toUpperCase()
            const o2 = obj2['Name'].toUpperCase()

            if (o1 < o2) {
                return -1
            }
            if (o1 > o2) {
                return 1
            }
            return 0
        })

        let letters = []

        for (const contact of contacts) {
            if (searchString == '') {
                const firstChar = contact.Name.slice(0,1).toUpperCase();
                
                
                if (letters.includes(firstChar) == false) {
                    $('.contact-list').append(`<p class="contact-letter">${firstChar}</p>`)
                    letters.push(firstChar)
                }
            } 
            
            if (contact.Name.toLowerCase().includes(searchString.toLowerCase())) {

                $('.contact-list').append(`
                    <div class="contact" id="contact-${contact.Name.replace(' ', '-')}">
                        <h3 class="contact-name">${contact.Name}</h3>
                    </div>
                `)

                $(`#contact-${contact.Name.replace(' ', '-')}`).click(function() {
                    // $('.contacts-page').removeClass('active')
                    switchPage('keypad-page')
                    $('#number-input').val(contact.Number)
                })
            }
        }
    }
})