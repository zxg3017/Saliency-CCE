function [hair_removed_result,M,K]=hair_remover_main(I)
    [M]=ncuLineCloseMatch(rgb2gray(I),12);
    [K]=stdDilateDarkest(255*M,255*0.75,255*0.65,40);
    [K]=stdDilateColorDist3(I,K,(K(:,:,1)<255),40,0.5,25,1);
    K=K(:,:,1)>=255;
    hair_removed_result=HairRemovMed(I,K,15);
end