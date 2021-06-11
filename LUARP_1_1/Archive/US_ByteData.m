% function [ByteData] = US_ByteData(Data32)
%
% Pete Smith

function  [ByteData] = US_ByteData(Data32)
    ByteData = [0 0 0 0];
    Hex32 = dec2hex(Data32,8);
    ByteData(1) = hex2dec(Hex32(1:2));
    ByteData(2) = hex2dec(Hex32(3:4));
    ByteData(3) = hex2dec(Hex32(5:6));
    ByteData(4) = hex2dec(Hex32(7:8));
end