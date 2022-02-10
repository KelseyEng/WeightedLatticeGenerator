%Kelsey Snapp
%Kab Lab
%4/2/21
%Checks to see if there is a folder by that name in the current working directory. If not, creates it.




function createFolder(folderName)

    if ~exist(folderName, 'dir')
       mkdir(folderName)
    end
    
end
    