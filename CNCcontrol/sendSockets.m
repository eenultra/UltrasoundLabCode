function sendSockets(socket, message)
    import java.net.Socket
    import java.io.*

    %flush the output buffer
    input_stream   = socket.getInputStream;            
    d_input_stream = DataInputStream(input_stream);    
    data_reader = DataReader(d_input_stream);        
    
    bytes_available = input_stream.available;
    while bytes_available ~= 0            
        junk = data_reader.readBuffer(bytes_available);                        
        bytes_available = input_stream.available;
    end
    
    output_stream   = socket.getOutputStream;
    d_output_stream = DataOutputStream(output_stream);

    % output the data over the DataOutputStream
    % Convert to stream of bytes
    d_output_stream.write([uint8(message)],0,length(message));
    %d_output_stream.writeBytes(message);
    d_output_stream.writeBytes(char(10));
    d_output_stream.flush;
end

