function Layout = resetAllFigures(Layout)
     cla(Layout.axesImageOne     ,'reset');
     cla(Layout.axesImageTwo     ,'reset');
     cla(Layout.axesImageThree   ,'reset');
     cla(Layout.axesImageFour    ,'reset');
     cla(Layout.axesImageFive    ,'reset');
     cla(Layout.axesImageSix     ,'reset');
     cla(Layout.axesImageSeven   ,'reset');
     cla(Layout.axesImageTen     ,'reset');
     
     set(Layout.axesImageOne   , 'XTick',[],'YTick',[], 'box', 'on');
     set(Layout.axesImageTwo   , 'XTick',[],'YTick',[], 'box', 'on');
     set(Layout.axesImageThree , 'XTick',[],'YTick',[], 'box', 'on');
     set(Layout.axesImageFour  , 'XTick',[],'YTick',[], 'box', 'on');
     set(Layout.axesImageFive  , 'XTick',[],'YTick',[], 'box', 'on');
     set(Layout.axesImageSix   , 'XTick',[],'YTick',[], 'box', 'on');
     set(Layout.axesImageSeven , 'XTick',[],'YTick',[], 'box', 'on');
     set(Layout.axesImageTen   , 'XTick',[],'YTick',[], 'box', 'on');
     
end