package net.bigpoint.darkorbit.gui.windows.components.gear
{
   import flash.display.Sprite;
   
   public class GearMenuContainer extends Sprite
   {
      
      public var submenus:Array = [];
      
      public var mainMenu:GearScroller;
      
      public function GearMenuContainer()
      {
         super();
      }
      
      public function addMainMenu(param1:GearScroller) : void
      {
         this.mainMenu = param1;
         this.addChild(param1);
      }
      
      public function removeAllSubmenus() : void
      {
         var _loc1_:GearScroller = null;
         for each(_loc1_ in this.submenus)
         {
            if(_loc1_ != null)
            {
               this.removeChild(_loc1_);
            }
         }
         this.submenus = [];
      }
      
      public function removeSubMenu(param1:int) : void
      {
         var _loc2_:GearScroller = this.submenus[param1] as GearScroller;
         if(_loc2_ != null)
         {
            this.removeChild(_loc2_);
            this.submenus[param1] = null;
         }
      }
      
      public function addSubMenu(param1:GearScroller) : void
      {
         this.submenus[param1.gearID] = param1;
         this.addChild(param1);
      }
      
      public function getSubMenu(param1:int) : GearScroller
      {
         return this.submenus[param1] as GearScroller;
      }
   }
}

