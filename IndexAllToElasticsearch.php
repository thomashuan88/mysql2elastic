<?php

namespace Module\Application\Command;

use Illuminate\Console\Command;
use Module\Application\Models\MvDatas\Video;
use App\Services\ElasticsearchService;


class IndexAllToElasticsearch extends Command
{
    use BaseScheduleTrait;

    protected $signature = 'search:sync-all-videos';
    protected $description = 'Index videos with relationships to Elasticsearch';

    private $client;

    public function __construct(ElasticsearchService $esService)
    {
        parent::__construct();
        $this->client = $esService;
    }

    protected function getLogChannel()
    {
        return 'command';
    }

    public function handle()
    {
        $logHead = "====IndexToElasticsearch====";
        $this->_start();
        $this->Log()->info($logHead);

        $settings = config('elasticsearch.settings');
        $mappings = config('elasticsearch.mappings');
        $index = config('elasticsearch.index_name');

        // Call the function to create the index if it doesn't exist
        $response = $this->client->createIndexIfNotExists($index, $settings, $mappings);
        $this->Log()->info($response); // Output the result of the operation

        $counter = 1;
        $total_sync = 0;
        $message = '';
        // Chunk through videos for memory efficiency
        Video::with(['channel', 'categories', 'actors', 'directors'])
            ->select([
                '*',
                query_cdn_path('mv_video.cover_h', 'cover_h_full'),
                query_cdn_path('mv_video.cover_v', 'cover_v_full')
            ])
            ->where('status', Video::STATUS_ENABLED) // only index video with enabled status
            ->chunk(100, function ($videos) use (&$counter, &$total_sync, &$message, $index) {
                $this->info('processing chunk no:' . $counter++);
                $bulkData = [];
                $rows_counter = 0;
                foreach ($videos as $video) {
                    $data = $this->transformVideo($video);
                    $bulkData[] = [
                        'index' => [
                            '_index' => $index,
                            '_id'    => $video->id,
                        ],
                    ];
                    $bulkData[] = $data;
                    $rows_counter++;
                }
                if (!empty($bulkData)) {
                    [$flag, $message] = $this->client->bulkIndex($bulkData);
                    if (!$flag) {
                        $this->Log()->error("Failed to index chunk no: {$counter}. Error: {$message}");
                        $this->error("Failed to index chunk no: {$counter}. Error: {$message}");
                        return false; // Stops chunking process
                    }
                    $total_sync += $rows_counter;
                }
            });

        $message = 'Total videos sync: ' . $total_sync;
        $this->Log()->info($message);
        $this->info($message);

        $this->_end();
        return 0;
    }

    /**
     * Transform the video model and its relationships into a searchable format.
     *
     * @param Video $video
     * @return array
     */
    private function transformVideo(Video $video): array
    {
        return [
            'title'         => $video->title,
            'sub_title'     => $video->sub_title,
            'third_title'   => $video->third_title,
            'third_title_type' => $video->third_title_type,

            'release_at'    => $video->release_at?->format('Y-m-d'),
            'year'          => $video->year,
            'video_language' => $video->video_language,
            'brief'         => $video->brief,

            'cover_h' => $video->cover_h_full,
            'cover_v' => $video->cover_v_full,
            'country' => $video->country,

            'total_episodes' => $video->total_episodes,
            'last_episodes' => $video->last_episodes,
            'is_end'        => $video->is_end,
            'ranking'        => $video->ranking,
            'vip'        => $video->vip,
            'playpoint'        => $video->play_point,
            'total_views'   => $video->total_views,
            'total_score'   => $video->total_score,

            'channel'       => $video->channel?->name, // Now returns a string
            'categories'    => $video->categories->pluck('name')->toArray(),
            'tags'          => $video->tags->pluck('name')->toArray(),
            'actors'        => $video->actors->pluck('name')->toArray(),
            'directors'     => $video->directors->pluck('name')->toArray(),

            'updated_at'    => $video->updated_at->format('Y-m-d H:i:s'),
            'created_at'    => $video->created_at->format('Y-m-d H:i:s'),
        ];
    }
}
