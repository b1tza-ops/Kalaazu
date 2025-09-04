package net.bigpoint.darkorbit.settings
{
   import net.bigpoint.darkorbit.gui.elements.SettingsField;
   
   public class Presetting
   {
      
      public var setQualityHigh:Array;
      
      public var setQualityGood:Array;
      
      public var setQualityMedium:Array;
      
      public var setQualityLow:Array;
      
      public function Presetting()
      {
         super();
         this.setQualityHigh = [];
         this.setQualityHigh.push(new PresettingItem(SettingsField.TYPE_QUALITY_BACKGROUND,Settings.QUALITY_HIGH));
         this.setQualityHigh.push(new PresettingItem(SettingsField.TYPE_QUALITY_POIZONE,Settings.QUALITY_HIGH));
         this.setQualityHigh.push(new PresettingItem(SettingsField.TYPE_QUALITY_SHIP,Settings.QUALITY_HIGH));
         this.setQualityHigh.push(new PresettingItem(SettingsField.TYPE_QUALITY_ENGINE,Settings.QUALITY_HIGH));
         this.setQualityHigh.push(new PresettingItem(SettingsField.TYPE_QUALITY_COLLECTABLE,Settings.QUALITY_HIGH));
         this.setQualityHigh.push(new PresettingItem(SettingsField.TYPE_QUALITY_EXPLOSION,Settings.QUALITY_HIGH));
         this.setQualityGood = [];
         this.setQualityGood.push(new PresettingItem(SettingsField.TYPE_QUALITY_BACKGROUND,Settings.QUALITY_GOOD));
         this.setQualityGood.push(new PresettingItem(SettingsField.TYPE_QUALITY_POIZONE,Settings.QUALITY_HIGH));
         this.setQualityGood.push(new PresettingItem(SettingsField.TYPE_QUALITY_SHIP,Settings.QUALITY_HIGH));
         this.setQualityGood.push(new PresettingItem(SettingsField.TYPE_QUALITY_ENGINE,Settings.QUALITY_HIGH));
         this.setQualityGood.push(new PresettingItem(SettingsField.TYPE_QUALITY_COLLECTABLE,Settings.QUALITY_HIGH));
         this.setQualityGood.push(new PresettingItem(SettingsField.TYPE_QUALITY_EXPLOSION,Settings.QUALITY_MEDIUM));
         this.setQualityMedium = [];
         this.setQualityMedium.push(new PresettingItem(SettingsField.TYPE_QUALITY_BACKGROUND,Settings.QUALITY_MEDIUM));
         this.setQualityMedium.push(new PresettingItem(SettingsField.TYPE_QUALITY_POIZONE,Settings.QUALITY_LOW));
         this.setQualityMedium.push(new PresettingItem(SettingsField.TYPE_QUALITY_SHIP,Settings.QUALITY_LOW));
         this.setQualityMedium.push(new PresettingItem(SettingsField.TYPE_QUALITY_ENGINE,Settings.QUALITY_LOW));
         this.setQualityMedium.push(new PresettingItem(SettingsField.TYPE_QUALITY_COLLECTABLE,Settings.QUALITY_LOW));
         this.setQualityMedium.push(new PresettingItem(SettingsField.TYPE_QUALITY_EXPLOSION,Settings.QUALITY_MEDIUM));
         this.setQualityLow = [];
         this.setQualityLow.push(new PresettingItem(SettingsField.TYPE_QUALITY_BACKGROUND,Settings.QUALITY_LOW));
         this.setQualityLow.push(new PresettingItem(SettingsField.TYPE_QUALITY_POIZONE,Settings.QUALITY_LOW));
         this.setQualityLow.push(new PresettingItem(SettingsField.TYPE_QUALITY_SHIP,Settings.QUALITY_LOW));
         this.setQualityLow.push(new PresettingItem(SettingsField.TYPE_QUALITY_ENGINE,Settings.QUALITY_LOW));
         this.setQualityLow.push(new PresettingItem(SettingsField.TYPE_QUALITY_COLLECTABLE,Settings.QUALITY_LOW));
         this.setQualityLow.push(new PresettingItem(SettingsField.TYPE_QUALITY_EXPLOSION,Settings.QUALITY_LOW));
      }
      
      public function getQualitySet(param1:int) : Array
      {
         var _loc2_:Array = null;
         switch(param1)
         {
            case Settings.QUALITY_LOW:
               _loc2_ = this.setQualityLow;
               break;
            case Settings.QUALITY_MEDIUM:
               _loc2_ = this.setQualityMedium;
               break;
            case Settings.QUALITY_GOOD:
               _loc2_ = this.setQualityGood;
               break;
            case Settings.QUALITY_HIGH:
            default:
               _loc2_ = this.setQualityHigh;
         }
         return _loc2_;
      }
   }
}

