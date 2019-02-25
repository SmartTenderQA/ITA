# -*- coding: utf-8 -*-


from datetime import datetime, timedelta

def smart_get_time(v=0, accuracy='m'):
    delta = int(v)
    time = datetime.now() + timedelta(days=delta)
    if accuracy == 'm':
        return ('{:%d.%m.%Y %H:%M}'.format(time))
    elif accuracy == 's':
        return ('{:%d.%m.%Y %H:%M:%S}'.format(time))
    elif accuracy == 'd':
        return ('{:%d.%m.%Y}'.format(time))
