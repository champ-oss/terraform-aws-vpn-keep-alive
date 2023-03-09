import os
import socket
from contextlib import closing

HOST = os.getenv('HOST', 'localhost')
PORT = int(os.getenv('PORT', '80'))
TIMEOUT = int(os.getenv('TIMEOUT', '3'))


def handler(_, __):
    print(f'connecting to {HOST}:{PORT}')
    with closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as sock:
        sock.settimeout(TIMEOUT)
        sock.connect((HOST, PORT))
        print('connected successfully')
        sock.close()


if __name__ == '__main__':
    handler(None, None)
