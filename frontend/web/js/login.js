var Login = function() {

    var handleLogin = function() {

        $('.login-form').validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-block', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            rules: {
                username: {
                    required: true
                },
                password: {
                    required: true
                },
                remember: {
                    required: false
                }
            },

            messages: {
                username: {
                    required: "Username is required"
                },
                password: {
                    required: "Password is required"
                }
            },

            invalidHandler: function(event, validator) { //display error alert on form submit 
                $('.alert-danger > span').text('Enter valid login and password');            
                $('.alert-danger', $('.login-form')).show();
            },

            highlight: function(element) { // hightlight error inputs
                $(element)
                    .closest('.form-group').addClass('has-error'); // set error class to the control group
            },

            success: function(label) {
                label.closest('.form-group').removeClass('has-error');
                label.remove();
            },

            errorPlacement: function(error, element) {
                error.insertAfter(element.closest('.input-icon'));
            },

            submitHandler: function(form) {
                var formData = $(form).serialize();

                $.ajax({
                    type: 'POST',
                    url: '/api/auth',
                    data: formData,
                    success: function(data, textStatus, jqXHR) {
                        token = JSON.parse(data);
                        $.cookie('bearer', token.bearer);
                        window.location = "/";
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        $('.alert-danger > span', $('.login-form')).text(jqXHR.responseText);
                        $('.alert-danger', $('.login-form')).show();
                    }
                });
            }
        });

        $('.login-form input').keypress(function(e) {
            if (e.which == 13) {
                if ($('.login-form').validate().form()) {
                    $('.login-form').submit(); //form validation success, call ajax form submit
                }
                return false;
            }
        });
    }

    var handleForgetPassword = function() {
        $('.forget-form').validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-block', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            ignore: "",
            rules: {
                email: {
                    required: true,
                    email: true
                }
            },

            messages: {
                email: {
                    required: "Email is required"
                }
            },

            invalidHandler: function(event, validator) { //display error alert on form submit   

            },

            highlight: function(element) { // hightlight error inputs
                $(element)
                    .closest('.form-group').addClass('has-error'); // set error class to the control group
            },

            success: function(label) {
                label.closest('.form-group').removeClass('has-error');
                label.remove();
            },

            errorPlacement: function(error, element) {
                error.insertAfter(element.closest('.input-icon'));
            },

            submitHandler: function(form) {
                var formData = $(form).serialize();

                $.ajax({
                    type: 'POST',
                    url: '/api/reset',
                    data: formData,
                    success: function(data, textStatus, jqXHR) {
                        jQuery('.login-form').show();
                        jQuery('.forget-form').hide();
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        $('.alert-danger > span', $('.forget-form')).text(jqXHR.responseText);
                        $('.alert-danger', $('.forget-form')).show();
                    }
                });
            }
        });

        $('.forget-form input').keypress(function(e) {
            if (e.which == 13) {
                if ($('.forget-form').validate().form()) {
                    $('.forget-form').submit();
                }
                return false;
            }
        });

        jQuery('#forget-password').click(function() {
            jQuery('.login-form').hide();
            jQuery('.forget-form').show();
        });

        jQuery('#back-btn').click(function() {
            jQuery('.login-form').show();
            jQuery('.forget-form').hide();
        });

    }

    var handleRegister = function() {

        $('.register-form').validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-block', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            ignore: "",
            rules: {

                fullname: {
                    required: true
                },
                gender: {
                    required: true,
                },
                height: {
                    required: true,
                },
                weight: {
                    required: true,
                },
                lifestyle: {
                    required: true,
                },
                diabetic: {
                    required: false,
                },
                email: {
                    required: true,
                    email: true
                },
                username: {
                    required: true
                },
                password: {
                    required: true
                },
                rpassword: {
                    required: false,
                    equalTo: "#register_password"
                },
                tnc: {
                    required: true
                }
            },

            messages: { // custom messages for radio buttons and checkboxes
                tnc: {
                    required: "Please accept terms first."
                }
            },

            invalidHandler: function(event, validator) { //display error alert on form submit   

            },

            highlight: function(element) { // hightlight error inputs
                $(element)
                    .closest('.form-group').addClass('has-error'); // set error class to the control group
            },

            success: function(label) {
                label.closest('.form-group').removeClass('has-error');
                label.remove();
            },

            errorPlacement: function(error, element) {
                if (element.attr("name") == "tnc") { // insert checkbox errors after the container                  
                    error.insertAfter($('#register_tnc_error'));
                } else if (element.closest('.input-icon').size() === 1) {
                    error.insertAfter(element.closest('.input-icon'));
                } else {
                    error.insertAfter(element);
                }
            },

            submitHandler: function(form) {
                var formData = $(form).serializeJSON({parseAll: "true"});

                $.ajax({
                    type: 'POST',
                    url: '/api/users',
                    contentType: "application/json",
                    data: JSON.stringify(formData),
                    success: function(data, textStatus, jqXHR) {
                        jQuery('.login-form').show();
                        jQuery('.register-form').hide();
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        $('.alert-danger > span', $('.register-form')).text(jqXHR.responseText);
                        $('.alert-danger', $('.register-form')).show();
                    }
                });
            }
        });

        $('.register-form input').keypress(function(e) {
            if (e.which == 13) {
                if ($('.register-form').validate().form()) {
                    $('.register-form').submit();
                }
                return false;
            }
        });

        jQuery('#register-btn').click(function() {
            jQuery('.login-form').hide();
            jQuery('.register-form').show();
        });

        jQuery('#register-back-btn').click(function() {
            jQuery('.login-form').show();
            jQuery('.register-form').hide();
        });
    }

    return {
        //main function to initiate the module
        init: function() {

            handleLogin();
            handleForgetPassword();
            handleRegister();

        }

    };

}();