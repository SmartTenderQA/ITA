# -*- coding: utf-8 -*-


def get_env_variable(env, env_variable):
    a = {
        'ITA': {
            'login': 'uitest',
            'password': '291263',
        },
        'ITA_web2016': {
            'login': 'uitest',
            'password': '291263',
        },
        'ITCopyUpgrade': {
            'login': 'uitest',
            'password': '689762156750',
        },
    }
    if env not in a:
        return env
    else:
        return a[env][env_variable]

