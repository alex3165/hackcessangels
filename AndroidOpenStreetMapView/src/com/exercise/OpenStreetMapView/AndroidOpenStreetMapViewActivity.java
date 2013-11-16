package com.exercise.OpenStreetMapView;

import org.osmdroid.api.IMapController;
import org.osmdroid.tileprovider.tilesource.ITileSource;
import org.osmdroid.tileprovider.tilesource.OnlineTileSourceBase;
import org.osmdroid.tileprovider.tilesource.XYTileSource;
import org.osmdroid.util.GeoPoint;
import org.osmdroid.views.MapView;
import org.osmdroid.ResourceProxy;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;

public class AndroidOpenStreetMapViewActivity extends Activity {
    private static final int TILE_SIZE = 512;
    private MapView myOpenMapView;
    private IMapController myMapController;

    public static final OnlineTileSourceBase MAPNIK = new XYTileSource("Mapnik",
            ResourceProxy.string.mapnik, 0, 20, TILE_SIZE, ".png",
            "http://a.tile.openstreetmap.fr/osmfr/", "http://b.tile.openstreetmap.fr/osmfr/",
            "http://c.tile.openstreetmap.fr/osmfr/");

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        final Context context = this;

        // Create a custom tile source
        final ITileSource tileSource = MAPNIK;

        // Create the mapview with the custom tile provider array
        myOpenMapView = new MapView(context, TILE_SIZE);// , new DefaultResourceProxyImpl(context),
                                                  // tileProviderArray);
        myOpenMapView.setTileSource(tileSource);
        myOpenMapView.setBuiltInZoomControls(true);
        myOpenMapView.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT,
                LayoutParams.MATCH_PARENT));

        myMapController = myOpenMapView.getController();
        myMapController.setZoom(13);
        myMapController.setCenter(new GeoPoint(48.8534100, 2.3488000));

        LinearLayout ll = new LinearLayout(this);
        ll.setOrientation(LinearLayout.VERTICAL);
        ll.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
        ll.setGravity(Gravity.CENTER);
        ll.addView(myOpenMapView);
        setContentView(ll);
    }
}