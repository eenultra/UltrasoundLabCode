function message = receiveLnSockets (socket, size)
    import java.net.Socket
    import java.io.*

    % get a buffered data input stream from the socket
    input_stream   = socket.getInputStream;
    d_input_stream = DataInputStream(input_stream);

       
    message = d_input_stream.readLine();
    message = char(message);
    return
    
    message(80)=0;
     for i = 1:size
         message(i) = d_input_stream.readByte();
         if (message(i) == 10)
             break;
         end
     end
    message = char(message);
end