package
{
    import org.flixel.FlxG;
    import org.flixel.FlxGroup;
    import org.flixel.FlxSound;
    import org.flixel.FlxSprite;

    public class Boomerang extends FlxGroup
    {
        /**
         * Boomerang Sprites
         */
        [Embed('../assets/Boomerang_2_cropped_scaled.png')] private var BoomerangImage:Class;
        public var boomerangSprite:FlxSprite;


        /**
         * Boomerang Sounds
         */
        [Embed('../assets/Hit_Hurt5.mp3')] private var BoomerangHitObstacle:Class;

        [Embed('../assets/Powerup15.mp3')] private var BoomerangFlying:Class;
        private var flyingSound:FlxSound;

        [Embed('../assets/Pickup_Coin5.mp3')] private var BoomerangCaught:Class;

        private var targetSprite:FlxSprite;
        private var startSprite:FlxSprite;

        private var position:Vector2D;
        private var targetPosition:Vector2D;
        private var startPosition:Vector2D;

        private var speed:Number;

        private var isThrown:Boolean;
        public var returning:Boolean;
        private var spinning:Boolean;

        public function Boomerang(x:int, y:int):void
        {

            flyingSound = new FlxSound();

            boomerangSprite = this.recycle(FlxSprite) as FlxSprite;
            boomerangSprite.x = 0;
            boomerangSprite.y = 0;
            boomerangSprite.antialiasing = true;
            boomerangSprite.loadGraphic(BoomerangImage);
            add(boomerangSprite);

            position = new Vector2D(0, 0);
            setBoomerangPosition(x, y);

            targetPosition = new Vector2D(0, 0);
            startPosition = new Vector2D(0, 0);

            targetSprite = this.recycle(FlxSprite) as FlxSprite;
            targetSprite.x = 0;
            targetSprite.y = 0;
            targetSprite.makeGraphic(10, 10, 0xffff1111);
            targetSprite.visible = false;
            add(targetSprite);

            startSprite = this.recycle(FlxSprite) as FlxSprite;
            startSprite.x = 0;
            startSprite.y = 0;
            startSprite.makeGraphic(10, 10, 0xffff1111);
            startSprite.visible = false;
            add(startSprite);

            speed = 8;

            isThrown = false;
            returning = false;
            spinning = false;
        }

        public function setBoomerangPosition(x:int, y:int):void
        {
            position.x = x;
            position.y = y;

            boomerangSprite.x = position.x;
            boomerangSprite.y = position.y;
        }

        public function setBoomerangAngle(angle:Number):void
        {
            boomerangSprite.angle = angle;
        }

        public function setAndShowTargets(x:int, y:int):void
        {
            if (!isThrown)
            {
                targetPosition.x = x;
                targetPosition.y = y;

                targetSprite.x = targetPosition.x;
                targetSprite.y = targetPosition.y;

                startPosition.x = boomerangSprite.x;
                startPosition.y = boomerangSprite.y;

                startSprite.x = startPosition.x;
                startSprite.y = startPosition.y;

          //      targetSprite.visible = true;
          //      startSprite.visible = true;
                returning = false;
            }
        }

        public function throwBoomerang():void
        {
        //    targetSprite.visible = false;
         //   startSprite.visible = false;
            isThrown = true;
            spinning = true;

            flyingSound.stop();
            flyingSound = FlxG.play(BoomerangFlying, 1.0, false);
        }

        public function caughtBoomerang():void
        {
            if (isThrown || spinning)
            {
                isThrown = false;
                spinning = false;

                flyingSound.stop();
                FlxG.play(BoomerangCaught);
                //targetSprite.visible = false;
                //startSprite.visible = false;
            }
        }

        public function moveToTarget():void
        {
            var theTarget:Vector2D;

            if (returning)
            {
                theTarget = startPosition;
            }
            else
            {
                theTarget = targetPosition;
            }


            var dirX:Number = theTarget.x - position.x;
            var dirY:Number = theTarget.y - position.y;

            var hypotenuse:Number = Math.sqrt(Math.pow(dirX, 2) + Math.pow(dirY, 2));
            dirX /= hypotenuse;
            dirY /= hypotenuse;

            var newX:Number = position.x + (dirX * speed);
            var newY:Number = position.y + (dirY * speed);

            var diffX:Number = newX - theTarget.x;
            var diffY:Number = newY - theTarget.y;

            var distanceFromTarget:Number = Math.sqrt(Math.pow(diffX, 2) + Math.pow(diffY, 2));

            if (distanceFromTarget > 5)
            {
                setBoomerangPosition(newX, newY);
            }
            else
            {
                if (returning)
                {
                    if (spinning)
                    {
                        spinning = false;
                        flyingSound.stop();
                        FlxG.play(BoomerangHitObstacle);
                    }
                }
                else
                {
                    returning = true;
                }

            }
        }

        public function spin():void
        {
            boomerangSprite.angle += speed;
        }

        public function hitObstacle():void
        {
            isThrown = false;
            spinning = false;
            returning = true;

            flyingSound.stop();
            FlxG.play(BoomerangHitObstacle);
        }

        override public function update():void
        {
            if (isThrown)
            {
                moveToTarget();
                if (spinning)
                {
                    spin();
                }
            }

            super.update();
        }
    }
}
