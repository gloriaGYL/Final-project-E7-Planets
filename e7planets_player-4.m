function [direction] = e7planets_player(map)
player_location = map.player.location;
%arrange scraps
size_scraps  = size(map.scraps);
number_scraps = size_scraps(1);
scrap_mat = zeros(number_scraps,4);
%simply helps with debugging
if size(player_location) == [34,2]
    p =1;
end
sizes = size(map.grid);
length = sizes(2);
height = sizes(1);
for p = 1: number_scraps
connected = 1;
    if connected
        scrap_location = [map.scraps(p).location];
        x_diff = abs(scrap_location(2) - player_location(end,2));
        y_diff = abs(scrap_location(1)-player_location(end,1));
        dist_upwarp = abs(height-map.scraps(p).location(1))+player_location(end,1);
        dist_downwarp = abs(height-player_location(end,1))+map.scraps(p).location(2);
        dist_leftwarp = abs(length-map.scraps(p).location(2))+player_location(end,2);
        dist_rightwarp = abs(length-player_location(end,2))+map.scraps(p).location(2);
        x_dist = min([x_diff,dist_leftwarp,dist_rightwarp]);
        y_dist = min([y_diff,dist_upwarp,dist_downwarp]);
        scrap_mat(p,1) = map.scraps(p).value/(x_dist+y_dist);
        scrap_mat(p,2) = map.scraps(p).value;
        scrap_mat(p,3:4) = map.scraps(p).location;
    else 
        scrap_mat(p,1) = length+height;
    end
end
[~,sorted] = sort(scrap_mat,1);
%so normally this sorts least to greatest, but because we want the highest
%value, we take the last entry
next_scrap = scrap_mat(sorted(end,1),3:4);
%scrap has been targeted, find main movement
if player_location(end,2) > next_scrap(2)
    if (player_location(end-1,2) < player_location(end,2))&& ~ ((player_location(end-1,2)== 1)&& player_location(end,2) == length)
        if player_location(end,1) > next_scrap(1)
            direction = 'U';
            next_location = [player_location(end,1)-1,player_location(end,2)];
        elseif player_location(end,1) < next_scrap(1)
            direction = 'D';
            next_location = [player_location(end,1)+1,player_location(end,2)];
        else
            direction = 'R';
            next_location = [player_location(end,1),player_location(end,2)+1];
        end
    else
        direction = 'L';
        next_location = [player_location(end,1),player_location(end,2)-1];
    end
elseif player_location(end,2) < next_scrap(2)
    if (player_location(end-1,2) > player_location(end,2)) && ~ ((player_location(end,2)== 1)&& player_location(end-1,2) == length)
        if player_location(end,1) > next_scrap(1)
            direction = 'U';
            next_location = [player_location(end,1)-1,player_location(end,2)];
        elseif player_location(end,1) < next_scrap(1)
            direction = 'D';
            next_location = [player_location(end,1)+1,player_location(end,2)];
        else
        direction = 'L';
        next_location = [player_location(end,1),player_location(end,2)-1];
        end
    else
        direction = 'R';
        next_location = [player_location(end,1),player_location(end,2)+1];
    end
elseif player_location(end,1) > next_scrap(1)
   if (player_location(end-1,1) < player_location(end,1)) 
        if player_location(end,2) > next_scrap(2)
            direction = 'L';
            next_location = [player_location(end,1),player_location(end,2)-1];
        elseif player_location(end,2) < next_scrap(2)
            direction = 'R';
            next_location = [player_location(end,1),player_location(end,2)+1];
        elseif player_location(end,1) == height
            if player_location(end-1,1) == 1
                direction = 'U';
                next_location = [player_location(end,1)-1,player_location(end,2)];
            else
                direction = 'D';
                next_location = [player_location(end,1)+1,player_location(end,2)];

            end
        else
        direction = 'D';
        next_location = [player_location(end,1)+1,player_location(end,2)];
        end
    else
        direction = 'U';
        next_location = [player_location(end,1)-1,player_location(end,2)];
    end
elseif player_location(end,1) < next_scrap(1) 
        if (player_location(end-1,1) > player_location(end,1)) && (player_location(end,1) > 1) 
            if player_location(end,2) > next_scrap(2)
                direction = 'L';
                next_location = [player_location(end,1),player_location(end,2)-1];
            elseif player_location(end,2) < next_scrap(2)
                direction = 'R';
                next_location = [player_location(end,1),player_location(end,2)+1];
            else
                direction = 'U';
                next_location = [player_location(end,1)-1,player_location(end,2)];
            end
        else
            direction = 'D';
            next_location = [player_location(end,1)+1,player_location(end,2)];
        end
end
% correct values if out of the grid
if next_location(1) > height
    next_location(1) = 1;
elseif next_location(1) < 1
    next_location(1) = height;
elseif next_location(2) > length
    next_location(2) = 1;
elseif next_location(2) < 1
    next_location(2) = length;
end
%wrap around move
if abs(height-next_scrap(1))+next_location(1)<abs(next_location(1)-next_scrap(1))
    %could wrap around up
       if direction == 'U' || direction =='D'
           if   map.grid(height,player_location(end,2))~=inf
               direction = 'U';
                next_location = [player_location(end,1)-1,player_location(end,2)];
           end
       end
elseif abs(height-player_location(end,1))+next_scrap(1) < abs(player_location(end,1)-next_scrap(1)) 
        if direction == 'U' ||direction =='D'
           if   map.grid(1,player_location(end,2))~=inf
                direction = 'D';
                next_location = [player_location(end,1)+1,player_location(end,2)];
           end
        end
end
if (abs(length-next_scrap(2))+player_location(end,2)<abs(player_location(end,2)-next_scrap(2))) 
        if direction == 'L'||direction == 'R'
            if map.grid(player_location(end,1),length)~= inf
                direction = 'L';
                next_location(2) = player_location(end,2)-1;
            end
        end
elseif (abs(length-player_location(end,2)) + next_scrap(2) < abs(next_scrap(2)-player_location(end,2)))
        if direction == 'L'||direction == 'R'
            if map.grid(player_location(end,1),1)~=inf
                direction = 'R';
                next_location(2) = player_location(end,2)+1;
            end
        end
end    
if next_location(1) > height
    next_location(1) = 1;
elseif next_location(1) < 1
    next_location(1) = height;
elseif next_location(2) > length
    next_location(2) = 1;
elseif next_location(2) < 1
    next_location(2) = length;
end
direction = asteroidcheck(map,direction,next_location,player_location,next_scrap);
%ghost evasion
if player_location(end,1) == 1
    up_one = height;
else
    up_one = player_location(end,1)-1;
end
if player_location(end,1) == height
    down_one = 1;
else
    down_one = player_location(end,1)+1;
end
if player_location(end,2) == 1
    left_one = length;
else
    left_one = player_location(end,2)-1;
end
if player_location(end,2) == length
    right_one = 1;
else
    right_one = player_location(end,2)+1;
end
do_not_move = ghost_evasion(map,direction);
for num_do_not_move = 1:numel(do_not_move)
    if strcmp(do_not_move(num_do_not_move),direction)
        %if going up/down
        if direction == 'U'||direction == 'D'
            %does player want to go left
            if player_location(end,2) > next_scrap(2) || abs(length-next_scrap(2))+player_location(end,2)<abs(player_location(end,2)-next_scrap(2))
                %is left a valid move
                if map.grid(player_location(end,1),left_one) ~= inf
                    direction = 'L';
                    %it is not, how about right
                elseif map.grid(player_location(end,1),right_one)~=inf
                    direction = 'R';
                    %okay both left and right are asteroid fields, just
                    %don't keep going in the same direction
                elseif direction == 'U'
                    direction = 'D';
                elseif direction == 'D'
                    direction = 'U';
                end   
                %same but wants to go right
            elseif player_location(end,2) < next_scrap(2) || abs(length-next_scrap(2))+player_location(end,2)>abs(player_location(end,2)-next_scrap(2))
                if map.grid(player_location(end,1),right_one)~=inf
                    direction = 'R';
                elseif map.grid(player_location(end,1),left_one) ~= inf
                    direction = 'L';
                elseif direction == 'U'
                    direction = 'D';
                elseif direction == 'D'
                    direction = 'U';
                end
            %okay so player is in the same column as the scrap, doesn't want to move left/right,
            %so just push it away from center    
            else
                sizes = size(map.grid);
                length = sizes(2);
                if player_location(end,2) < length/2
                    direction = 'L';
                    next_location = [player_location(end,1),left_one];
                    if map.grid(next_location) ~=inf
                        return
                    else
                        direction = 'R';
                        next_location = [player_location(end,1),right_one]; 
                    end
                else 
                    direction = 'R';
                    next_location = [player_location(end,1),right_one];
                    if map.grid(next_location(1),next_location(2)) ~=inf   
                        return
                    else
                        direction = 'L';
                        next_location = [player_location(end,1),left_one];
                    end
                end
            end
        elseif direction == 'L' || direction == 'R'
            if player_location(end,1) > next_scrap(1) || abs(height-next_scrap(1))+player_location(end,1)<abs(player_location(end,1)-next_scrap(1))
                if map.grid(up_one,player_location(end,2)) ~=inf
                    direction = 'U';
                elseif map.grid(down_one,player_location(end,2)) ~=inf
                    direction = 'D';
                elseif direction == 'R'
                    direction = 'L';
                elseif direction == 'L'
                    direction = 'R';
                end
            elseif player_location(end,1) < next_scrap(1) || abs(height-next_scrap(1))+player_location(end,1)>abs(player_location(end,1)-next_scrap(1))
                if map.grid(down_one,player_location(end,2)) ~=inf
                    direction = 'D';
                elseif map.grid(up_one,player_location(end,2)) ~=inf
                    direction = 'U';
                elseif direction == 'R'
                    direction = 'L';
                elseif direction == 'L'
                    direction = 'R';
                end
            %so it is going left/right, ghost is moving to the same space,
                %and in the same column as the scrap
            else
                 %last resortpush ship away from center
                sizes = size(map.grid);
                height = sizes(1);
                if player_location(end,1) < height/2
                    direction = 'U';
                    next_location = [up_one,player_location(end,2)];
                    if map.grid(next_location(1),next_location(2)) ~=inf
                        
                    else
                        direction = 'D';
                        next_location = [down_one,player_location(end,2)];
                    end
                else 
                    direction = 'D';
                    next_location = [down_one,player_location(end,2)];
                    if map.grid(next_location) ~= inf
                        
                    else
                        direction = 'U';
                        next_location = [up_one,player_location(end,2)];
                    end
                end
            end
        end
    end   
end
end
        
        

function [direction, next_location] = asteroidcheck(map, direction,next_location,player_location,next_scrap)
%check if next move will hit an asteroid field
sizes = size(map.grid);
length = sizes(2);
height = sizes(1);
if player_location(end,1) == 1
    up_one = height;
else
    up_one = player_location(end,1)-1;
end
if player_location(end,1) == height
    down_one = 1;
else
    down_one = player_location(end,1)+1;
end
if player_location(end,2) == 1
    left_one = length;
else
    left_one = player_location(end,2)-1;
end
if player_location(end,2) == length
    right_one = 1;
else
    right_one = player_location(end,2)+1;
end
if map.grid(next_location(1),next_location(2)) == Inf
    %that move is up
    if direction == 'U'
        %if scrap is to the left
        if player_location(end,2) > next_scrap(2)
            direction = 'L';
            next_location = [player_location(end,1),left_one];
            %if going left would just put player back near block
            if map.grid(up_one,left_one) ~=inf
                return
            else
                %if the player went to the left they would probably get
                %stuck again
                direction = 'R';
                %so send them right
                next_location = [player_location(end,1),right_one];
                if player_location(end-1,2) == right_one
                    %but if you went left last turn
                    direction = 'L';
                    next_location = [player_location(end,1),left_one];
                    return
                end
                if map.grid(next_location) ~=Inf
                    return
                else
                    direction = 'L';
                    next_location = [player_location(end,1),left_one];
                end
            end
        %if scrap is to the right
        elseif player_location(end,2) <next_scrap(2)
            direction = 'R';
            next_location = [player_location(end,1),right_one];

            %if going right would put player near the block
            if map.grid(up_one,right_one) ~=inf
                if player_location(end,2) == player_location(end-1,2)-1
                    direction = 'L';
                    next_location = [player_location(end,1),left_one];
                else
                    return
                end
            else
                %you can't go the other way, so try going around
                direction = 'L';
                next_location = [player_location(end,1),left_one];
                return
            end
       %if player is in the same column as a scrap
        elseif player_location(end-1,2) == right_one
            %did you go left last move
            direction = 'L';
            next_location = [player_location(end,1),left_one];
            %yes you did, and going left again is valid
            if map.grid(player_location(end,1),left_one) ~=inf
                return
            else
                %yes you went left, but you can't go there again so go
                %right
                direction = 'R';
                next_location = [player_location(end,1),right_one];
                return
            end
        %same column still, but moved right last turn
        elseif player_location(end-1,2)+1 == player_location(end,2)
            direction = 'R';
            next_location = [player_location(end,1),right_one];
            %is that move valid
            if map.grid(player_location(end,1),right_one) ~=inf
                %yes
                return
            else
                %it is not valid, so as a default go left
                direction = 'L';
                next_location = [player_location(end,1),left_one];

                return
            end
        %so you are in the same column as the scrap, want to go up but can't, and you went up last turn    
        else
            %don't have the energy to code a better moving algorithim in
            %this case, so as a default push ship away from center
            sizes = size(map.grid);
            length = sizes(2);
            if player_location(end,2) < length/2
                direction = 'L';
                next_location = [player_location(end,1),left_one];
                return
            else 
                direction = 'R';
                next_location = [player_location(end,1),right_one];
                return
            end
            
        end
    elseif direction == 'D' 
        %if wants to go down, and cannot
        if player_location(end,2) > next_scrap(2)
            %if the ship also wants to go left at some point
            direction = 'L';
            next_location = [player_location(end,1),left_one];
            %check to see if moving puts player at risk for asteroid field
            %again
            if map.grid(down_one,left_one) ~=inf
               %it does not
                return
            else
                %it does
                if player_location(end-1,2)-1 == player_location(end,2)
                    direction = 'L';
                    next_location = [player_location(end,1),left_one];
                    %if you went left last turn, go left again 
                    return
                end
                %if you did not go left last turn, go right
                direction = 'R';
                next_location = [player_location(end,1),right_one];

                return
            end
        elseif player_location(end,2) <next_scrap(2)
            %so the ship may want to go right at some point
            direction = 'R';
            next_location = [player_location(end,1),right_one];

            if map.grid(down_one,right_one) ~=inf
                %does it put you at risk to get stuck again, no
                return
            else
                %yes it does
                if player_location(end-1,2)+1 == player_location(end,2)
                    direction = 'R';
                    next_location = [player_location(end,1),left_one];
                    %did you go right last turn, yes
                    return
                end
                %no you did not, go left
                direction = 'L';
                next_location = [player_location(end,1),left_one];

                return
            end
            % so you can't go down and the ship is in the same column as
            % the scrap
        elseif player_location(end-1,2) > player_location(end,2)
            direction = 'L';
            next_location = [player_location(end,1),left_one];
            %did you go left last turn, yes
            if map.grid(player_location(end,1),left_one)~= inf
                %is going left again valid,yes
                return
            else
                %no it is not, go right 
                direction = 'R';
                next_location = [player_location(end,1),right_one];
                return
            end
            %same condition, but did you go right last turn
        elseif player_location(end-1,2) < player_location(end,2)
            %yes you did, probably go right again
            direction = 'R';
            next_location = [player_location(end,1),right_one];
            if map.grid(player_location(end,1),right_one) ~=inf
                %move is valid
                return
            else
                %it is not valid, so go left
                direction = 'L';
                next_location = [player_location(end,1),left_one];
            end
            
        else
           %push ship away from center, last resort
            sizes = size(map.grid);
            length = sizes(2);
            if player_location(end,2) < length/2
                direction = 'L';
                next_location = [player_location(end,1),left_one];
                if map.grid(next_location) ~=inf
                    return
                else
                    direction = 'R';
                    next_location = [player_location(end,1),right_one]; 
                end
            else 
                direction = 'R';
                next_location = [player_location(end,1),right_one];
                if map.grid(next_location(1),next_location(2)) ~=inf   
                    return
                else
                    direction = 'L';
                    next_location = [player_location(end,1),left_one];
                end
            end
        end
        %want to go left but can't
    elseif direction == 'L'
        if player_location(end,1) > next_scrap(1)
            %might you want to go up,yes
            direction = 'U';
            next_location = [up_one,player_location(end,2)];
            if map.grid(up_one,left_one) ~=inf
                %yeah you can go up, and the move after looks good too
                return
            else
                %you can maybe go up, but move after looks iffy
                if player_location(end-1,1) - 1 == player_location(end,1)
                    %did you go up last turn,yes
                    if map.grid(up_one,player_location(end,2)) ~=Inf
                        return
                    else
                        direction = 'R';
                        next_location = [player_location(end,1),right_one];
                    end

                else
                    %you did not, so just go down
                    if map.grid(down_one,player_location(end,2)) ~=Inf    
                        direction = 'D';
                        next_location = [down_one,player_location(end,2)];
                        return
                    else
                        direction = 'U';
                        next_location = [up_one,player_location(end,2)]; 
                        return
                    end
                end
            end
            %might you want to go down
        elseif player_location(end,1) <next_scrap(1)
            direction = 'D';
            next_location = [down_one,player_location(end,2)];
            if map.grid(down_one,left_one) ~=inf
                %is the move after good too,yes
                return
            else
                if player_location(end-1,1)+1 == player_location(end,1)
                    %no it's not, but you went down last turn so do it
                    %again
                    if map.grid(down_one,player_location(end,2)) ~=inf
                        return
                    else
                        direction = 'R';
                        next_location = [player_location(end,1),right_one];
                    end
                else
                    %you did not go down last turn, so go up
                direction = 'U';
                next_location = [up_one,player_location(end,2)];
                return
                end
            end
            %you are in the same row as the scrap and want to go left but
            %can't
        elseif player_location(end,1) > player_location(end-1,1)
            %did you go down last turn, yes
            direction = 'D';
            next_location = [down_one,player_location(end,2)];
            if map.grid(down_one,left_one) ~=inf
                %the move after seems valid too, execute
                return
            else
                %logical move after is not valid, so try other routes
                if player_location(end-1,1) == up_one
                    %did you go down last move,yes
                    direction = 'D';
                    next_location = [down_one,player_location(end,2)];
                    return
                end
                %you did not go down last time, so go up
                direction = 'U';
                next_location = [up_one,player_location(end,2)];
                return
            end
        elseif player_location(end-1,1) > player_location(end,1)
            %player went up last turn
            direction = 'U';
            next_location = [up_one,player_location(end,2)];
            if map.grid(up_one,left_one) ~=inf
                %does the move after look good? yes, execute
                return
            else
                %no it does not look good, go down instead
                if player_location(end-1,1) == down_one
                    %did you go up last move,yes
                    direction = 'U';
                    next_location = [up_one,player_location(end,2)];
                    return
                end
                direction = 'D';
                next_location = [down_one,player_location(end,2)];
                return
            end
        else
            %last resort, push ship away from center
            sizes = size(map.grid);
            height = sizes(1);
            if player_location(end,1) < height/2
                direction = 'U';
                next_location = [up_one,player_location(end,2)];
                return
            else 
                direction = 'D';
                next_location = [down_one,player_location(end,2)];
                return
            end
        end
        %wants to go right but can't
    elseif direction == 'R'
        if player_location(end,1) > next_scrap(1)
            %player may want to go up at some point
            direction = 'U';
            next_location = [up_one,player_location(end,2)];
            if map.grid(up_one,right_one) ~=inf
                %does the move after look good? yes
                return
            else
                %move after does not look good
                if player_location(end-1,1) -1 == player_location(end,1)
                    %went up last turn, do it again
                    return
                else
                    %did not go up last turn, try going down
                    if map.grid(down_one,player_location(end,2))~=Inf
                        direction = 'D';
                        next_location = [down_one,player_location(end,2)];
                        return
                    else
                        direction = 'L';
                        next_location = [player_location(end,1),left_one];
                    end
                end
            end
            %may want to go down at some point
        elseif player_location(end,1) <next_scrap(1)
            direction = 'D';
            next_location = [down_one,player_location(end,2)];
            if map.grid(down_one,right_one) ~=inf
                %does potential move after look good,yes
                return
            else
                %it does not look good, so run more checks
                if player_location(end-1,1) == up_one
                    %player went down last turn
                    direction = 'D';
                    next_location = [down_one,player_location(end,2)];
                    return
                end
                %player did not go down last turn, so go up
                if map.grid(up_one,player_location(end,2)) ~=inf
                    direction = 'U';
                    next_location = [up_one,player_location(end,2)];
                    return
                else
                    direction = 'D';
                    next_location = [down_one,player_location(end,2)];
                end
            end
            %player is in the same column as the scrap
        elseif player_location(end-1,1) < player_location(end,1)
            %did player go down last turn
            direction = 'D';
            next_location = [down_one,player_location(end,2)];
            if map.grid(down_one,right_one) ~=inf
                %is potential move after that a valid one
                return
            else
                %it is 
                if player_location(end-1,1)+1 == player_location(end,1)
                    %if player went down last turn
                    if map.grid(down_one,player_location(end,2)) ~=Inf
                        direction = 'D';
                        next_location = [down_one,player_location(end,2)];
                        return
                    else
                        direction = 'L';
                        next_location = [player_location(end,1),left_one];                        
                    return
                    end
                end
                %did not go down last turn, try going up
                direction = 'U';
                next_location = [up_one,player_location(end,2)];
                return
            end
            %player is in the same column as scrap but moved up last turn
        elseif player_location(end-1,1) > player_location(end,1)
            direction = 'U';
            next_location = [up_one,player_location(end,2)];
            %is the potential move after a good one
            if map.grid(up_one,right_one) ~=inf
                %yes
                return
            else
                %no it is not valid
                if player_location(end-1,1)-1 == player_location(end,1)
                    %if player went up last turn
                    direction = 'U';
                    return
                end
                %did not go up last turn
                direction = 'D';
                next_location = [down_one,player_location(end,2)];

                return
            end
        else
            %last resortpush ship away from center
            sizes = size(map.grid);
            height = sizes(1);
            if player_location(end,1) < height/2
                direction = 'U';
                next_location = [up_one,player_location(end,2)];
                if map.grid(next_location(1),next_location(2)) ~=inf
                    return
                else
                    direction = 'D';
                    next_location = [down_one,player_location(end,2)];
                end
            else 
                direction = 'D';
                next_location = [down_one,player_location(end,2)];
                if map.grid(next_location) ~= inf
                    return
                else
                    direction = 'U';
                    next_location = [up_one,player_location(end,2)];
                end
            end
        end
    end
end   

end
function [do_not_move] = ghost_evasion(map,direction)
player_location = map.player.location;
size_ghosts = size(map.ghosts);
do_not_move = [];
number_ghosts = size_ghosts(1);
x = player_location(end,1);
y = player_location(end,2);
for each_ghost = 1:number_ghosts
    ghost_location = [map.ghosts(each_ghost).location];
    n_distance = player_location(end,1) - ghost_location(end,1); %This determines how far and where the ghost is compared to the player
    m_distance = player_location(end,2) - ghost_location(end,2);
    direction_y = ghost_location(end-1,1)-ghost_location(end,1);
	direction_x = ghost_location(end-1,2)-ghost_location(end,2);
    
    if direction_x == 1
		ghost_direction = 'L';
	elseif direction_x == -1
		ghost_direction = 'R';
    elseif direction_y == -1
		ghost_direction = 'D';
	elseif direction_y == 1
		ghost_direction = 'U';
    else 
        ghost_direction = 'No';
    end
     [height,width] = size(map.grid);
    
    if (ghost_location(end,1) == 1) && (strcmp(ghost_direction,'U'))
        ghost_direction = 'D';
    end
    if (ghost_location(end,1) == height) && (strcmp(ghost_direction,'D'))
        ghost_direction = 'U';
    end
    if (ghost_location(end,2) == width) && (strcmp(ghost_direction,'R'))
        ghost_direction = 'L';
    end
    if (ghost_location(end,2) == 1) && (strcmp(ghost_direction,'L'))
        ghost_direction = 'R';
    end
        
    if ((n_distance == 1) && (m_distance == 1)) && strcmp(ghost_direction ,'R') %UP direction.
        do_not_move = [do_not_move,'U'];
    elseif ((n_distance == 1) && (m_distance == -1)) && strcmp(ghost_direction ,'L')
        do_not_move = [do_not_move,'U'];
    elseif ((n_distance == 2) && (m_distance == 0)) && strcmp(ghost_direction ,'D')
        do_not_move = [do_not_move,'U'];
    elseif ((n_distance == 1) && (m_distance == 0)) && strcmp(ghost_direction,'D')
        do_not_move = [do_not_move,'U'];
    end
    
    
    if ((n_distance == -1) && (m_distance == 1)) && strcmp(ghost_direction ,'R') %DOWN direction
        do_not_move = [do_not_move,'D'];
    elseif ((n_distance == -1) && (m_distance == -1)) && strcmp(ghost_direction ,'L')
        do_not_move = [do_not_move,'D'];
    elseif ((n_distance == -2) && (m_distance == 0)) && strcmp(ghost_direction ,'U')
        do_not_move = [do_not_move,'D'];
    elseif ((n_distance == -1) && (m_distance == 0)) && strcmp(ghost_direction ,'U')
        do_not_move = [do_not_move,'D'];
    end
    
  
    
    if ((n_distance == 1) && (m_distance == 1)) && strcmp(ghost_direction ,'D')%LEFT direction
        do_not_move = [do_not_move,'L'];
    elseif ((n_distance == -1) && (m_distance == 1)) && strcmp(ghost_direction ,'U')
        do_not_move = [do_not_move,'L'];
    elseif ((n_distance == 0) && (m_distance == 2)) && strcmp(ghost_direction ,'R')
        do_not_move = [do_not_move,'L'];
    elseif ((n_distance == 0) && (m_distance == 1)) && strcmp(ghost_direction ,'R')
        do_not_move = [do_not_move,'L'];
    end

    
    if ((n_distance == -1) && (m_distance == -1)) && strcmp(ghost_direction ,'U') %RIGHT direction
        do_not_move = [do_not_move,'R'];
    elseif ((n_distance == 1) && (m_distance == -1)) && strcmp(ghost_direction ,'D')
        do_not_move = [do_not_move,'R'];
    elseif ((n_distance == 0) && (m_distance == -2)) && strcmp(ghost_direction ,'L')
        do_not_move = [do_not_move,'R'];
    elseif ((n_distance == 0) && (m_distance == -1)) && strcmp(ghost_direction,'L')
        do_not_move = [do_not_move,'R'];
    end
    check_above = x-1;
    if check_above == 0
       check_above = height;
    end
     
    if strcmp(direction,'U') && map.grid(check_above,y) >0 && ~isinf(map.grid(check_above,y))
        if strcmp(ghost_direction,'R')
             distance = abs(ghost_location(end,1) -  check_above)+ abs(ghost_location(end,2)+1 - y);
        elseif strcmp(ghost_direction,'L')
             distance = abs(ghost_location(end,1) -  check_above)+ abs(ghost_location(end,2)-1 - y);
        elseif strcmp(ghost_direction,'U')
             distance = abs(ghost_location(end,1)-1 -  check_above)+ abs(ghost_location(end,2) - y);
        elseif strcmp(ghost_direction,'D')
             distance = abs(ghost_location(end,1)+1 -  check_above)+ abs(ghost_location(end,2) - y);
        end
        if distance <= map.grid(check_above,y)
             disp('check')
             do_not_move = [do_not_move,'U'];
        end
    end    
    
       check_down = x+1;
    if check_down == height+1
       check_down = 1;
    end
    if strcmp(direction,'D') && map.grid(check_down,y) >0 && ~isinf(map.grid(check_down,y))
        if strcmp(ghost_direction,'R')
             distance = abs(ghost_location(end,1) -  check_down)+ abs(ghost_location(end,2)+1 - y);
        elseif strcmp(ghost_direction,'L')
             distance = abs(ghost_location(end,1) -  check_down)+ abs(ghost_location(end,2)-1 - y);
        elseif strcmp(ghost_direction,'U')
             distance = abs(ghost_location(end,1)-1 -  check_down)+ abs(ghost_location(end,2) - y);
        elseif strcmp(ghost_direction,'D')
             distance = abs(ghost_location(end,1)+1 -  check_down)+ abs(ghost_location(end,2) - y);
        end
        if distance <= map.grid(check_down,y)
             disp('check')
             do_not_move = [do_not_move,'D'];
        end
    end 
    
       check_left = y-1;
    if check_left == 0
       check_left = width;
    end
    if strcmp(direction,'L') && map.grid(x,check_left) >0 && ~isinf(map.grid(x,check_left))
        if strcmp(ghost_direction,'R')
             distance = abs(ghost_location(end,1) -  x)+ abs(ghost_location(end,2)+1 - check_left);
        elseif strcmp(ghost_direction,'L')
             distance = abs(ghost_location(end,1) -  x)+ abs(ghost_location(end,2)-1 - check_left);
        elseif strcmp(ghost_direction,'U')
             distance = abs(ghost_location(end,1)-1 -  x)+ abs(ghost_location(end,2) - check_left);
        elseif strcmp(ghost_direction,'D')
             distance = abs(ghost_location(end,1)+1 -  x)+ abs(ghost_location(end,2) - check_left);
        end
        if distance <= map.grid(x,check_left)
             disp('check')
             do_not_move = [do_not_move,'L'];
        end
    end 

       check_right = y+1;
    if check_right == width+1
       check_right = 1;
    end
    if strcmp(direction,'R') && map.grid(x,check_right) >0 && ~isinf(map.grid(y,check_right))
        if strcmp(ghost_direction,'R')
             distance = abs(ghost_location(end,1) -  x)+ abs(ghost_location(end,2)+1 - check_right);
        elseif strcmp(ghost_direction,'L')
             distance = abs(ghost_location(end,1) -  x)+ abs(ghost_location(end,2)-1 - check_right);
        elseif strcmp(ghost_direction,'U')
             distance = abs(ghost_location(end,1)-1 -  x)+ abs(ghost_location(end,2) - check_right);
        elseif strcmp(ghost_direction,'D')
             distance = abs(ghost_location(end,1)+1 -  x)+ abs(ghost_location(end,2) - check_right);
        end
        if distance <= map.grid(x,check_right)
             disp('check')
             do_not_move = [do_not_move,'R'];
        end
    end 
%     a = do_not_move; %THIS MAKES THE PLAYER WAIT FOR THE GHOST TO PASS
%     for k = 1:numel(do_not_move)
%         if strcmp(do_not_move(k),'U') && direction == 'U'
%             direction = [];
%         end
%         if strcmp(do_not_move(k),'D') && direction == 'D'
%             direction = '[]';
%         end
%         if strcmp(do_not_move(k),'L') && direction == 'L'
%             direction = '[]';
%         end
%         if strcmp(do_not_move(k),'R') && direction == 'R'
%             direction = [];
%         end
%     end
%     for k = 1:numel(do_not_move)  %THIS MAKES THE PLAYER MOVE IF IT IS
%     ABOUT TO BE HIT BY A GHOST. SHOULD NOT WORK AS I KEPT ALL DIRECTIONS
%     UPPER CASE TO BE IMPLEMENTED INTO THE MAIN CODE.
%         if strcmp(do_not_move(k),'u') && direction == 'U'
%             direction = 'R';
%         end
%         if strcmp(do_not_move(k),'d') && direction == 'D'
%             direction = 'L';
%         end
%         if strcmp(do_not_move(k),'l') && direction == 'L'
%             direction = 'U';
%         end
%         if strcmp(do_not_move(k),'r') && direction == 'R'
%             direction = 'D';
%         end
%     end
end
end
