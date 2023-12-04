function result = eulersMethod(vectorField, initialPosition, stoppingTime, stepSize)
    currentPosition = initialPosition;
    currentTime = 0;
    % num_iterations = round(stoppingTime);
    result = [currentTime, currentPosition];
    

    while currentTime < stoppingTime
        derivative = vectorField(currentPosition);
        
        currentPosition = currentPosition + stepSize * derivative;
        
        currentTime = currentTime + stepSize;
        
        result = [result; currentTime, currentPosition];
    end
end
