$(function() {
    function updateContactList(searchString) {

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
                    <div class="contact" id="contact-${contact.Name.replace(' ', '-').replace('(', '').replace(')', '')}">
                        <h3 class="contact-name">${contact.Name}</h3>
                    </div>
                `)

                $(`#contact-${contact.Name.replace(' ', '-').replace('(', '').replace(')', '')}`).click(function() {
                    $('.contact-info-page').addClass('active')
                    $('.contact-info-img').html(contact.Name.slice(0,1).toUpperCase())
                    $('.contact-info-img').attr("id",contact.Name)
                    $('#contact-info-name-inp').val(contact.Name)
                    $('#contact-info-number-inp').val(contact.Number)
                })
            }
        }
    }

    updateContactList('')

    $('#new-contact').click(function() {
        $('.add-contact-page').addClass('active')
    })
    
    $('#cancel-add-contact').click(function() {
        $('.add-contact-page').removeClass('active')
        $('.add-contact-input').val('')
    })
    
    $('#cancel-info-contact').click(function() {
        $('.contact-info-page').removeClass('active')
        $('.contact-info-input').val('')
    })

    $('#confirm-info-contact').click(function() {
        $('.contact-info-page').removeClass('active')
        
        fetch(`https://${window.script}/editContact`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                name: $('#contact-info-name-inp').val(),
                number: $('#contact-info-number-inp').val(),
                id: $('.contact-info-img').attr("id"),
            })
        }).then((data) => data.json()).then((data) => {
            window.contacts = data.contacts
            updateContactList('')
        })

        $('.add-contact-input').val('')

    })

    $('#confirm-add-contact').click(function() {
        $('.add-contact-page').removeClass('active')
        
        fetch(`https://${window.script}/addContact`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                name: $('#contact-name-inp').val(),
                phoneNumber: $('#contact-number-inp').val()
            })
        }).then((data) => data.json()).then((data) => {
            window.contacts = data.contacts
            updateContactList('')
        })

        $('.add-contact-input').val('')

    })

    $('#remove-contact').on('click', function() {
        $('.contact-info-page').removeClass('active')
        
        fetch(`https://${window.script}/delContact`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                number: $('#contact-info-number-inp').val()
            })
        }).then((data) => data.json()).then((data) => {
            window.contacts = data.contacts
            updateContactList('')
        })

    })

    $('#contact-search').keyup(function() {
        updateContactList($('#contact-search').val())
    })
})