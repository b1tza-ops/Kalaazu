package net.bigpoint.darkorbit.menu
{
   public class ActionButtonPattern
   {
      
      public var actionID:int;
      
      private var menuID:int;
      
      public var resKey:String;
      
      private var alwaysExist:Boolean;
      
      public var isActiveAtStart:Boolean = true;
      
      private var cooldown:Boolean;
      
      private var counter:Boolean;
      
      private var stdIcon:String;
      
      private var hoverIcon:String;
      
      private var selectedIcon:String;
      
      public var isSelectable:Boolean = true;
      
      private var languageKey:String;
      
      private var ammobar:Boolean;
      
      public var isCustomizable:Boolean = true;
      
      public var section:String;
      
      public var canActivate:Boolean;
      
      public function ActionButtonPattern(param1:int, param2:int, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String = null, param9:Boolean = false)
      {
         super();
         this.section = param8;
         this.actionID = param1;
         this.menuID = param2;
         this.resKey = param3;
         this.stdIcon = param4;
         this.hoverIcon = param5;
         this.selectedIcon = param6;
         this.languageKey = param7;
         this.canActivate = param9;
      }
      
      public function getMenuID() : int
      {
         return this.menuID;
      }
      
      public function getResKey() : String
      {
         return this.resKey;
      }
      
      public function isAlwaysExist() : Boolean
      {
         return this.alwaysExist;
      }
      
      public function setAlwaysExist(param1:Boolean) : void
      {
         this.alwaysExist = param1;
      }
      
      public function hasCooldown() : Boolean
      {
         return this.cooldown;
      }
      
      public function setCooldown(param1:Boolean) : void
      {
         this.cooldown = param1;
      }
      
      public function hasCounter() : Boolean
      {
         return this.counter;
      }
      
      public function setCounter(param1:Boolean) : void
      {
         this.counter = param1;
      }
      
      public function getStdIcon() : String
      {
         return this.stdIcon;
      }
      
      public function getHoverIcon() : String
      {
         return this.hoverIcon;
      }
      
      public function getSelectedIcon() : String
      {
         return this.selectedIcon;
      }
      
      public function getLanguageKey() : String
      {
         return this.languageKey;
      }
      
      public function isAmmobar() : Boolean
      {
         return this.ammobar;
      }
      
      public function setAmmobar(param1:Boolean) : void
      {
         this.ammobar = param1;
      }
      
      public function toString() : String
      {
         return "ActionButtonPattern actionID:" + this.actionID + " menuID:" + this.menuID + " resKey:" + this.resKey;
      }
   }
}

