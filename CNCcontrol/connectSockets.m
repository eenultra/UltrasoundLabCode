function socket = connectSockets(host, timeout)
    import java.net.Socket
    import java.io.*

    % throws if unable to connect
    socket = Socket(host, 5025);
    socket.setSoTimeout(timeout);
end

