function message = receiveSockets (socket, size)
    import java.net.Socket
    import java.io.*

    % get a buffered data input stream from the socket
    input_stream   = socket.getInputStream;
    d_input_stream = DataInputStream(input_stream);

     for i = 1:size
         message(i) = d_input_stream.read();
     end
    message = char(message);
end

