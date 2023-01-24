$(function() {
    function getData() {
        fetch('https://n4_bank/getTransactions', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                account: 'bank'
            })
        }).then(resp => resp.json()).then(transactions => {
            $('.bank-transaction-list').empty()
            transactions.forEach(transaction => {
                $('.bank-transaction-list').append(`
                <div class="bank-transaction-element">
                    <p class="bank-transaction-description">${transaction.description}</p>
                    <p class="bank-transaction-amount">${transaction.amount} kr</p>
                </div>
                `)
            });
        })

        fetch('https://n4_bank/getAccountMoney', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                account: 'bank'
            })
        }).then(resp => resp.json()).then(money => {
            $('#bank-cash-amount').html(money.cash)
            $('#bank-amount').html(money.bank)
        })

        fetch('https://n4_bank/getAccounts', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                account: 'bank'
            })
        }).then(resp => resp.json()).then(accounts => {
            $('.bank-accounts-list').empty()
            accounts.forEach(account => {
                if (account.name != 'money') {
                    $('.bank-accounts-list').append(`
                        <div class="bank-account-element">
                            <p class="bank-account-name">${account.label}</p>
                            <p class="bank-account-amount">${account.money}</p>
                        </div>
                    `)
                }
            })
        })
    }

    function switchPage(page) {
        $('.bank-page').removeClass('active')
        $(`#${page}`).addClass('active')
        $('.bank-nav-btn').removeClass('active')
        $(`#${page}-btn`).addClass('active')
    }

    getData()

    $('#bank-homepage-btn').on('click', function() {switchPage('bank-homepage')})
    $('#bank-accounts-btn').on('click', function() {switchPage('bank-accounts')})

    $('.swedbank').hide()
    
    $('#bank-login-btn').on('click', function() {
        $.get('../apps/[bankid]/bankid.html', function (data) {
            $('#app-container').append(data)

            newBankIDAccept('Logga in på Swedbank', function() {
                $('.swedbank').show()
                $('.swedbank-login').hide()
                $('#app-container .bankid').remove()
            }, function() {
                $('#app-container .bankid').remove()
            })
        })
    })
})