%by James McLaughlan
%University of Leeds
%Jan 2020

function stSetSpeed

global ST

stCommand('SPEED ?');
L = fscanf(ST, '%s');

id1 = find(L == '?');% find '.' as only 1sgf after it before end of value
id2 = find(L == 'O');

disp(['Current Speed: ' num2str(L(id1+1:id2-1))]);

changeSpeed = input('Do you want to change speed? y/n : ','s');

    if strcmp(changeSpeed,'y')
        newSpeed = input('What is the new speed? (range 2-65000) ');
        if (newSpeed < 2) || (newSpeed > 65000)
            disp('invalid speed')
            return
        end
        stCommand([num2str(newSpeed) ' SPEED !']);
       
    pause(0.5);
    stCommand('SPEED ?');pause(0.1);
    L2 = fscanf(ST, '%s');

    id3 = find(L2 == '?');% 
    id4 = find(L2 == 'O');

    disp(['Set Speed: ' num2str(L2(id3+1:id4-1))]);   
    
    end
    
end
    