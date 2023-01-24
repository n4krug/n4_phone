$(function() {
    // $('.swish-homepage').hide()
    $('.new-swish').hide()
    $('.swish-succes').hide()
    
    $('.swish-btn').on('click', function() {
        $('.swish-homepage').hide()
        $('.new-swish').show()
    })
    
    $('.close-swish').on('click', function() {
        $('.swish-homepage').show()
        $('.new-swish').hide()
    })

    $('.send-swish').on('click', function() {
        // $.post('https://va_phone/swishSend', JSON.stringify({
        //     number: $('#swish-phone-number').val(),
        //     amount: $('#swish-amount').val(),
        // }))

        $.get('./apps/bankid.html', function (data) {
            $('#app-container').append(data)

            newBankIDAccept('Betala med Swish', sendSwish, function() {
                $('#app-container .bankid').remove()
            })
        })
    })
    
    function sendSwish() {
        $('#app-container .bankid').remove()
        
        fetch(`https://${window.script}/swishSend`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                number: $('#swish-phone-number').val(),
                amount: $('#swish-amount').val(),
            })
        }).then(resp => resp.json()).then(resp => {
            if (resp.status == 'ok') {
                $('#succes-amount').html($('#swish-amount').val())
                $('#succes-name').html(resp.name)
                $('#succes-phone-number').html($('#swish-phone-number').val())

                $('#swish-phone-number').val('')
                $('#swish-amount').val('')
        
                $('.swish-succes').show()
                $('.new-swish').hide()
            }
        });
    }



    $('.swish-contact-btn').click(function() {
        $('.contacts-page').addClass('active')
        updateContactList('')
    })
    
    $('.cancel-contact-btn').click(function() {
        $('.contacts-page').removeClass('active')
    })

    $('.close-succes').on('click', function() {
        $('.swish-homepage').show()
        $('.swish-succes').hide()
    })


    // * Kontakt script

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
                    $('.contacts-page').removeClass('active')
                    $('#swish-phone-number').val(contact.Number)
                })
            }
        }
    }
})