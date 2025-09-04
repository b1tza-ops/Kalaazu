package net.bigpoint.darkorbit
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.media.SoundChannel;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.audio.AudioManager;
   
   public class Interference extends Sprite
   {
      
      private var timer:Timer;
      
      private var background:Bitmap;
      
      private var barMask:Sprite;
      
      private var bar:Sprite;
      
      private var w:int;
      
      private var h:int;
      
      private var noiseChannel:SoundChannel;
      
      private var startAlpha:Number;
      
      public var updateInMsec:int = 50;
      
      public var diff:Number = 0.5;
      
      public var duration:Number = -1;
      
      public var playSound:Boolean = true;
      
      public var minFadeOutSec:int = 1;
      
      public var maxFadeOutSec:int = 6;
      
      public var minFadeInMsec:int = 20;
      
      public var maxFadeInMsec:int = 500;
      
      public var fadeOut:Boolean = true;
      
      public function Interference(param1:int, param2:int)
      {
         super();
         this.w = param1;
         this.h = param2;
      }
      
      private function handleTimer(param1:TimerEvent) : void
      {
         this.background.bitmapData.noise(Math.floor(1000 * Math.random()),0,255,7,true);
      }
      
      public function start() : void
      {
         this.startAlpha = alpha;
         this.background = new Bitmap(new BitmapData(this.w,this.h));
         this.addChild(this.background);
         this.barMask = new Sprite();
         this.barMask.graphics.beginFill(16777215);
         this.barMask.graphics.drawRect(0,0,this.w,this.h);
         this.addChild(this.barMask);
         this.bar = new Sprite();
         this.bar.graphics.beginFill(16777215);
         this.bar.graphics.drawRect(0,0,this.w,this.h / 4);
         this.bar.alpha = 0.5;
         this.addChild(this.bar);
         this.bar.mask = this.barMask;
         this.moveBar();
         if(this.fadeOut)
         {
            this.startFadeOut();
         }
         this.timer = new Timer(this.updateInMsec,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.handleTimer);
         this.timer.start();
         if(this.playSound)
         {
            this.noiseChannel = AudioManager.playSoundEffect(42,true,true);
         }
         if(this.duration != -1)
         {
            TweenMax.delayedCall(this.duration,this.cleanup);
         }
      }
      
      private function fadeOutInterference() : void
      {
         if(this.noiseChannel != null)
         {
            AudioManager.removeLoop(this.noiseChannel);
         }
         TweenLite.to(this,0.25,{
            "alpha":this.startAlpha - this.diff,
            "onComplete":this.handleFadeOut
         });
      }
      
      private function handleFadeOut() : void
      {
         var _loc1_:int = Main.getRandomCount(this.minFadeInMsec,this.maxFadeInMsec);
         TweenMax.killDelayedCallsTo(this.fadeIn);
         TweenMax.delayedCall(_loc1_ / 1000,this.fadeIn);
      }
      
      private function fadeIn() : void
      {
         TweenLite.to(this,0.25,{
            "alpha":this.startAlpha,
            "onComplete":this.startFadeOut
         });
         if(this.playSound)
         {
            this.noiseChannel = AudioManager.playSoundEffect(42,true,true);
         }
      }
      
      private function startFadeOut() : void
      {
         var _loc1_:int = Main.getRandomCount(this.minFadeOutSec,this.maxFadeOutSec);
         TweenMax.killDelayedCallsTo(this.fadeOutInterference);
         TweenMax.delayedCall(_loc1_,this.fadeOutInterference);
      }
      
      private function moveBar() : void
      {
         this.bar.y = -this.bar.height;
         TweenLite.to(this.bar,4,{
            "ease":Quad.easeOut,
            "y":height,
            "onComplete":this.moveBar
         });
      }
      
      public function cleanup() : void
      {
         if(this.timer != null)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.handleTimer);
         }
         if(parent != null && parent.contains(this))
         {
            parent.removeChild(this);
         }
         TweenMax.killTweensOf(this.bar);
         TweenMax.killDelayedCallsTo(this.fadeOutInterference);
         TweenMax.killDelayedCallsTo(this.fadeIn);
         if(this.noiseChannel != null)
         {
            AudioManager.removeLoop(this.noiseChannel);
         }
      }
   }
}

