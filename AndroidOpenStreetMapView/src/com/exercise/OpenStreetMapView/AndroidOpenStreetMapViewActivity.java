package com.exercise.OpenStreetMapView;

import org.osmdroid.DefaultResourceProxyImpl;
import org.osmdroid.api.IMapController;
import org.osmdroid.tileprovider.IRegisterReceiver;
import org.osmdroid.tileprovider.MapTileProviderArray;
import org.osmdroid.tileprovider.modules.MapTileDownloader;
import org.osmdroid.tileprovider.modules.MapTileFilesystemProvider;
import org.osmdroid.tileprovider.modules.MapTileModuleProviderBase;
import org.osmdroid.tileprovider.modules.NetworkAvailabliltyCheck;
import org.osmdroid.tileprovider.modules.TileWriter;
import org.osmdroid.tileprovider.tilesource.ITileSource;
import org.osmdroid.tileprovider.tilesource.OnlineTileSourceBase;
import org.osmdroid.tileprovider.tilesource.TileSourceFactory;
import org.osmdroid.tileprovider.tilesource.XYTileSource;
import org.osmdroid.tileprovider.util.SimpleRegisterReceiver;
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
    private MapView myOpenMapView;
    private IMapController myMapController;

    public static final OnlineTileSourceBase OSMFR = new XYTileSource("osmfr",
            ResourceProxy.string.cyclemap, 0, 20, 256, ".png",
            "http://a.tile.openstreetmap.fr/osmfr/", "http://b.tile.openstreetmap.fr/osmfr/",
            "http://c.tile.openstreetmap.fr/osmfr/");

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        final Context context = this;
        final Context applicationContext = context.getApplicationContext();
        final IRegisterReceiver registerReceiver = new SimpleRegisterReceiver(applicationContext);

        // Create a custom tile source
        final ITileSource tileSource = TileSourceFactory.CYCLEMAP;

        // Create a file cache modular provider
        final TileWriter tileWriter = new TileWriter();
        final MapTileFilesystemProvider fileSystemProvider = new MapTileFilesystemProvider(
                registerReceiver, tileSource);

        // Create a download modular tile provider
        final NetworkAvailabliltyCheck networkAvailabliltyCheck = new NetworkAvailabliltyCheck(
                context);
        final MapTileDownloader downloaderProvider = new MapTileDownloader(tileSource, tileWriter,
                networkAvailabliltyCheck);

        // Create a custom tile provider array with the custom tile source and the custom tile
        // providers
        final MapTileProviderArray tileProviderArray = new MapTileProviderArray(tileSource,
                registerReceiver, new MapTileModuleProviderBase[] { fileSystemProvider,
                        downloaderProvider });

        // Create the mapview with the custom tile provider array
        myOpenMapView = new MapView(context, 256, new DefaultResourceProxyImpl(context), tileProviderArray);

        myOpenMapView.setBuiltInZoomControls(true);
        myOpenMapView.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,
                LayoutParams.FILL_PARENT));

        myMapController = myOpenMapView.getController();
        myMapController.setZoom(10);
        myMapController.setCenter(new GeoPoint(48.8534100, 2.3488000));

        LinearLayout ll = new LinearLayout(this);
        ll.setOrientation(LinearLayout.VERTICAL);
        ll.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
        ll.setGravity(Gravity.CENTER);
        ll.addView(myOpenMapView);
        setContentView(ll);
    }
}