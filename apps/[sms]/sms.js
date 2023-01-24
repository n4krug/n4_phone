$(function(){

    function update() {

        fetch(`https://${window.script}/getSMSConversations`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
        }).then(resp => resp.json()).then(conversationsConst => { 
            // let conversations = window.sms
            let conversations = conversationsConst

            conversations.sort((obj1, obj2) => {
                const o1 = obj1.Messages[obj1.Messages.length - 1]['Timestamp']
                const o2 = obj2.Messages[obj2.Messages.length - 1]['Timestamp']
                
                if (o1 > o2) {
                    return -1
                }
                if (o1 < o2) {
                    return 1
                }
                return 0
            })

            window.sms = conversations
            const contacts = window.contacts

            
            $('.conversation-list').empty()
            conversations.forEach(convo => {
                let numbers = []
                convo.Numbers.forEach(number => {
                    if(number != window.phonenumber) numbers.push(number)
                })

                let names = numbers

                contacts.forEach(contact => {
                    index = numbers.indexOf(contact.Number)
                    if (index > -1) {
                        names[index] = contact.Name
                    }
                })

                let unread = false

                convo.Messages.forEach(message => {
                    if (!message.ReadBy.includes(window.phonenumber)) {
                        unread = true
                    }
                })

                $('.conversation-list').append(`
                    <div class="conversation${unread ? ' notification' : ''}" id="${convo.ConversationId}">
						<p class="conversation-image">${names[0][0].toUpperCase()}</p>
						<div class="conversation-column">
							<h3 class="conversation-name">${names}</h3>
							<p class="last-message">${convo.Messages[convo.Messages.length - 1].Text}</p>
						</div>
					</div>
                `)

                $('.conversation').on('click', function() {
                    conversation($(this).attr('id'))
                })
            })
        })
    }

    // update()

    function conversation(identifier) {
        chatpage()

        fetch(`https://${window.script}/getSMSConversations`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
        }).then(resp => resp.json()).then(conversations => { 
            // let conversations = window.sms
            window.sms = conversations
        let texts = []
        let conversation = []

        conversations.forEach(convo => {
            if (convo.ConversationId == identifier) {
                texts = convo.Messages
                conversation = convo
            }
        })
        
        let numbers = []
        conversation.Numbers.forEach(number => {
            if(number != window.phonenumber) numbers.push(number)
        })

        let names = numbers

        window.contacts.forEach(contact => {
            index = numbers.indexOf(contact.Number)
            if (index > -1) {
                names[index] = contact.Name
            }
        })

        fetch(`https://${window.script}/markRead`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                ConversationId: conversation.ConversationId
            })
        })

        $('.conversation-header').attr('id', identifier)
        $('.conversation-header .conversation-image').html(names[0][0].toUpperCase())
        $('.conversation-header .conversation-title').html(names)
    
        $('.sms-container').empty()
        var photoRegex = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|]).(?:jpg|gif|png)/ig;
        texts.forEach(text => {
            $('.sms-container').prepend(`
                <div class="sms-message ${text.From == window.phonenumber ? 'sent' : 'received'}">
                    <p class="content">${text.Text.replace(photoRegex, `<img src="$&" alt="">`)}</p>
                </div>
            `)
        });
        $('.sms-message .content img').on('mouseover', function(){
            $('#big-image').attr('src', $(this).attr('src'))
        }).on('mouseout', function(){
            $('#big-image').attr('src', "")
        })
        $('.sms-message .content img').on('click', function(){
            CopyText($(this).attr('src'))
        })

        $('#sms-input').unbind('keyup')
        $('#sms-input').on('keyup', function(e) {
            if(e.key == 'Enter') {
                fetch(`https://${window.script}/sendText`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({
                        ConversationId: $('.conversation-header').attr('id'),
                        message: {
                            Text: $('#sms-input').val(),
                            Timestamp: Date.now(),
                            From: window.phonenumber,
                            ReadBy: [window.phonenumber]
                        }
                    })
                })
                $('.sms-container').prepend(`
                    <div class="sms-message sent">
                        <p class="content">${$('#sms-input').val().replace(photoRegex, `<img src="$&" alt="">`)}</p>
                    </div>
                `)
                $('#sms-input').val('')
            }
        })
        })
    }

    function homepage() {
        $('.conversations-page').show()
        $('.conversation-page').hide()
        $('.new-conversation-page').hide()
        update()
    }
    
    
    function chatpage() {
        $('.conversations-page').hide()
        $('.new-conversation-page').hide()
        $('.conversation-page').show()
    }
    
    function newpage() {
        $('.conversations-page').hide()
        $('.conversation-page').hide()
        $('.new-conversation-page').show()
    }
   
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
                        <div class="contact" id="contact-${contact.Name.replace(' ', '-')}">
                            <h3 class="contact-name">${contact.Name}</h3>
                        </div>
                    `)

                    $(`#contact-${contact.Name.replace(' ', '-')}`).click(function() {
                        $('.contacts-page').removeClass('active')
                        $('#new-sms-number').val(contact.Number)
                    })
                }
            }
        // })
    }

    $('#contact-search').keyup(function() {
        updateContactList($('#contact-search').val())
    })

    $('.cancel-contact-btn').click(function() {
        $('.contacts-page').removeClass('active')
    })

    if(!$('#app-container').hasClass('fromNotif')) homepage()
    
    $('#new-sms-contact').on('click', function() {
        $('.contacts-page').addClass('active')
        updateContactList('')
    })

    $('.sms-back').on('click', homepage)
    $('#new-conversation').on('click', newpage)

    $('#new-sms-input').on('keyup', function(e) {
        if(e.key == 'Enter') {
            fetch(`https://${window.script}/createConvo`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    targetNumber: $('#new-sms-number').val(),
                    message: {
                        Text: $('#new-sms-input').val(),
                        Timestamp: Date.now(),
                        From: window.phonenumber,
                        ReadBy: [window.phonenumber]
                    }
                })
            }).then(resp => resp.json()).then(cbData => {
                // update()
                conversation(cbData)
            })

            // fetch(`https://n4_phone/sendText`, {
            //     method: 'POST',
            //     headers: {
            //         'Content-Type': 'application/json; charset=UTF-8',
            //     },
            //     body: JSON.stringify({
            //         targetNumber: $('#new-sms-number').val(),
            //         message: $('#new-sms-input').val()
            //     })
            // })

            // fetch(`https://n4_phone/smsNumberToIdentifier`, {
            //     method: 'POST',
            //     headers: {
            //         'Content-Type': 'application/json; charset=UTF-8',
            //     },
            //     body: JSON.stringify({
            //         number: $('#new-sms-number').val()
            //     })
            // }).then(resp => resp.json()).then(identifier => {
            //     conversation(identifier)
            // })


            $('#new-sms-number').val('')
            $('#new-sms-input').val('')


        }
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
