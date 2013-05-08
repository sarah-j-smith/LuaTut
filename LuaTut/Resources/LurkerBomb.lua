x, y = game.getPosition(self)
dragonDist = game.distance(x, y, dragonX, dragonY)
coinDist = game.distance(x, y, endCoinX, endCoinY)
lurkerSpeed = 0.002
if (dragonDist > 300) then
    -- dragon far away, go lurk and wait by the end coin
    if (coinDist > 100) then
        newx = x + ((endCoinX - x) * lurkerSpeed)
        newy = y + ((endCoinY - y) * lurkerSpeed)
        game.setPosition(self, newx, newy)
    end
else
    -- lurker sees dragon and gives chase
    lurkerSpeed = 0.01
    newx = x + ((dragonX - x) * lurkerSpeed)
    newy = y + ((dragonY - y) * lurkerSpeed)
    game.setPosition(self, newx, newy)
end
