import os
import socket
from unittest import TestCase


class Test(TestCase):

    def test_handler_connected_successfully(self) -> None:
        """
        create a local listener and validate the connection is successful
        """
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.bind(('', 0))  # bind to a random available port
            sock.listen(1)
            os.environ['HOST'] = 'localhost'
            os.environ['PORT'] = str(sock.getsockname()[1])
            os.environ['TIMEOUT'] = '1'
            import vpn_keep_alive
            assert vpn_keep_alive.handler(None, None) is None

    def test_handler_failed_connection(self) -> None:
        """
        validate an exception is thrown when unable to connect
        """
        import vpn_keep_alive
        with self.assertRaises(ConnectionRefusedError):
            vpn_keep_alive.handler(None, None)
