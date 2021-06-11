%by James McLaughlan
%University of Leeds
%Jan 2020

function stSetAcc

global ST

stCommand('ACCEL ?');
L = fscanf(ST, '%s');

id1 = find(L == '?');% find '.' as only 1sgf after it before end of value
id2 = find(L == 'O');

disp(['Current Acceleration: ' num2str(L(id1+1:id2-1))]);

changeAcc = input('Do you want to change acceleration? y/n : ','s');

    if strcmp(changeAcc,'y')
        newAcc = input('What is the new acceleration? (range 100-5000) ');
        if (newAcc < 100) || (newAcc > 5000)
            disp('invalid acceleration')
            return
        end
        stCommand([num2str(newAcc) ' ACCEL !']);
       
    pause(0.5);
    stCommand('ACCEL ?');pause(0.1);
    L2 = fscanf(ST, '%s');

    id3 = find(L2 == '?');% 
    id4 = find(L2 == 'O');

    disp(['Set Acceleration: ' num2str(L2(id3+1:id4-1))]);   
    
    end
    
end
    