c = 0.5; %?????
tidssteg = 0.1;
sluttid = 7; 
antalTidssteg = sluttid/tidssteg; 
antalPartiklar = 200; 
antalRutor = 100; 
partikelMatris = zeros(antalTidssteg, antalPartiklar, 2); % Matris för partikelpositioner
densitetMatris = zeros(antalTidssteg, antalRutor, 3); % Matris för densitetsdata
partikelMatris(1,:,:) = rand(antalPartiklar,2); % Startpositioners lumpas

hastighet = @(x, y) [y; 1 - x];

% Beräkna varje partikels bana
for tid = 1:antalTidssteg-1
    for partikel = 1:antalPartiklar
        nuvarandeX = partikelMatris(tid,partikel,1);
        nuvarandeY = partikelMatris(tid,partikel,2);
        slumpRorelse = sqrt(tidssteg)*randn; % Lägger till slumpmässig rörelse
        partikelMatris(tid+1,partikel,:) = squeeze(partikelMatris(tid,partikel,:)) + tidssteg*hastighet(nuvarandeX,nuvarandeY) + slumpRorelse;
    end
end

sidaRuta = 1/sqrt(antalRutor); % Längden på varje ruta
rutaX = 1; 
rutaY = 1; 

% Uppdatera beräkningen av partikelbanor för att inkludera diffusion
for tid = 1:antalTidssteg-1
    for partikel = 1:antalPartiklar
        nuvarandeX = partikelMatris(tid, partikel, 1);
        nuvarandeY = partikelMatris(tid, partikel, 2);
        slumpRorelse = sqrt(2*c*tidssteg) * randn(1, 2); % Diffusionskomponent
        hastighetsvektor = hastighet(nuvarandeX, nuvarandeY);
        uppdatering = tidssteg * hastighetsvektor' + slumpRorelse;
        partikelMatris(tid+1, partikel, :) = squeeze(partikelMatris(tid, partikel, :))' + uppdatering;
    end
end





% Iterera över rutor och tidssteg för att beräkna densitet
for ruta = 1:antalRutor
    for tid = 1:antalTidssteg
        antalIPartition = 0;
        for partikel = 1:antalPartiklar
            posPartikelX = partikelMatris(tid,partikel,1);
            posPartikelY = partikelMatris(tid,partikel,2);
            if (rutaX-1)*sidaRuta <= posPartikelX && posPartikelX < rutaX*sidaRuta && (rutaY-1)*sidaRuta <= posPartikelY && posPartikelY <= rutaY*sidaRuta
                antalIPartition = antalIPartition + 1;
            end
        end
        densitetMatris(tid, ruta, 1:3) = [rutaX*sidaRuta; rutaY*sidaRuta; antalIPartition/antalPartiklar];
    end
    % Uppdatera rutindelningen
    if mod(ruta, sqrt(antalRutor)) == 0
        rutaX = 1;
        rutaY = rutaY + 1;
    else
        rutaX = rutaX + 1;
    end
end


% Plotting av partikelbanor
figure;
hold on;
title('Partikelbanor');
xlabel('x');
ylabel('y');
for partikel = 1:antalPartiklar
    plot(partikelMatris(:, partikel, 1), partikelMatris(:, partikel, 2));
end

% Förbered figurer för densitetsplotting
figure;
densitetsAxel = gca;
title('Densitetsfördelning över tid');
xlabel('x');
ylabel('y');

% Animerad plot av densitetsfördelning
for tid = 1:antalTidssteg
    densitetsData = reshape(densitetMatris(tid, :, 3), sqrt(antalRutor), sqrt(antalRutor));
    imagesc('XData', densitetsAxel.XLim, 'YData', densitetsAxel.YLim, 'CData', densitetsData);
    colorbar;
    pause(0.1); % Paus mellan varje tidssteg för att skapa en animeringseffekt
end

