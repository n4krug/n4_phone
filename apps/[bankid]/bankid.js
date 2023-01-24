function newBankIDAccept(sourceApp, cb, backcb) {
    $('.default-page').addClass('hidden')
    $('.payment-page').removeClass('hidden')

    // $('.user-name').html(name)
    $('.payment-source').html(sourceApp)
    $('.payment-accept-btn').click(cb)
    $('#payment-back-btn').click(backcb)
}

$(function () {

    $('.default-page').removeClass('hidden')
    $('.payment-page').addClass('hidden')

    // newBankIDAccept('Swedbank AB test', 'Gurra Gurrason test', function() {
    //     $('.default-page').removeClass('hidden')
    //     $('.payment-page').addClass('hidden')
    // }, function() {
    //     $('.default-page').removeClass('hidden')
    //     $('.payment-page').addClass('hidden')
    // })
})