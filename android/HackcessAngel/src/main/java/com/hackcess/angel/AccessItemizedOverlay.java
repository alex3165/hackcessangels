package com.hackcess.angel;

import android.graphics.Point;
import android.graphics.drawable.Drawable;

import org.osmdroid.ResourceProxy;
import org.osmdroid.api.IMapView;
import org.osmdroid.views.overlay.ItemizedOverlay;
import org.osmdroid.views.overlay.OverlayItem;

import java.util.ArrayList;

public class AccessItemizedOverlay extends ItemizedOverlay {
    private ArrayList<OverlayItem> mOverlays = new ArrayList<OverlayItem>();

    public AccessItemizedOverlay(Drawable pDefaultMarker, ResourceProxy pResourceProxy) {
        super(pDefaultMarker, pResourceProxy);
    }

    public void addOverlay(OverlayItem overlay) {
        mOverlays.add(overlay);
        populate();
    }

    @Override
    protected OverlayItem createItem(int i) {
        return mOverlays.get(i);
    }

    @Override
    public int size() {
        return mOverlays.size();
    }

    @Override
    public boolean onSnapToItem(int i, int i2, Point point, IMapView iMapView) {
        return false;
    }
}
