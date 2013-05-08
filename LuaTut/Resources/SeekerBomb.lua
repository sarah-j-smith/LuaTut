x, y = game.getPosition(self);
seekerToDragonDist = game.distance(x, y, dragonX, dragonY)
if (seekerToDragonDist < 400) then
    -- seeker sees dragon and gives chase
    seekerSpeed = 0.01
    newx = x + ((dragonX - x) * seekerSpeed)
    newy = y + ((dragonY - y) * seekerSpeed)
    game.setPosition(self, newx, newy)
end
